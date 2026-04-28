import os
from flask import Flask, request, jsonify
import torch
from model import MultiModalTransformer

app = Flask(__name__)

# Load Model
model = MultiModalTransformer()
model_path = "aura_model.pth"

if os.path.exists(model_path):
    # weights_only=True is safe for loading state_dicts, suppressing the Future Warning
    model.load_state_dict(torch.load(model_path, map_location=torch.device('cpu'), weights_only=True))
    model.eval()
    print("Loaded trained model.")
else:
    print("Warning: 'aura_model.pth' not found. Using untrained model for demo purposes.")

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.json
        
        # Parse inputs
        b_data = data.get("baseline", [])
        v_data = data.get("vocal", [])
        l_data = data.get("linguistic", [])
        
        if not b_data or not v_data or not l_data:
            return jsonify({"error": "Missing input features."}), 400
            
        b_feat = torch.tensor([b_data], dtype=torch.float32)
        v_feat = torch.tensor([v_data], dtype=torch.float32)
        l_feat = torch.tensor([l_data], dtype=torch.float32)
        
        # Predict
        with torch.no_grad():
            output = model(b_feat, v_feat, l_feat)
            
        burnout_risk_index = output.item()
        
        return jsonify({
            "burnout_risk_index": round(burnout_risk_index, 4),
            "status": "success"
        })
        
    except Exception as e:
        return jsonify({"error": str(e), "status": "failed"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
