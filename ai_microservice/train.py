import json
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader
from model import MultiModalTransformer

class AuraDataset(Dataset):
    def __init__(self, baseline_file, vocal_file, linguistic_file):
        with open(baseline_file, 'r') as f:
            self.baseline = json.load(f)
        with open(vocal_file, 'r') as f:
            self.vocal = json.load(f)
        with open(linguistic_file, 'r') as f:
            self.linguistic = json.load(f)
            
        # Ensure they have the same length for simple pairing
        self.length = min(len(self.baseline), len(self.vocal), len(self.linguistic))
        
        self.energy_state_map = {"Vitality": 0.0, "Fatigue": 0.5, "Burnout": 1.0}

    def __len__(self):
        return self.length

    def __getitem__(self, idx):
        b = self.baseline[idx]
        v = self.vocal[idx]
        l = self.linguistic[idx]
        
        # Baseline features (5 dims)
        b_features = torch.tensor([
            b["age"] / 100.0,
            b["economic_struggle_index"],
            b["distance_from_hospital_km"] / 100.0,
            b["hours_caregiving_per_week"] / 168.0,
            b["support_system_strength"]
        ], dtype=torch.float32)
        
        # Vocal features (4 dims)
        v_features = torch.tensor([
            v["pitch_hz"] / 300.0,
            v["jitter_percent"],
            v["shimmer_percent"],
            v["pause_duration_s"]
        ], dtype=torch.float32)
        
        # Linguistic features (3 dims)
        l_features = torch.tensor([
            l["syntax_fragmentation_score"],
            l["lexical_sentiment_score"],
            1.0 if l["is_masked_distress"] else 0.0
        ], dtype=torch.float32)
        
        # Target: The target for our demo will be a combination of baseline stress, energy state, and true distress.
        # This gives a pseudo ground-truth "Burnout Risk Index"
        target_stress = (b["baseline_stress_weight"] + self.energy_state_map[v["energy_state_label"]] + l["true_distress_level"]) / 3.0
        target = torch.tensor([target_stress], dtype=torch.float32)
        
        return b_features, v_features, l_features, target

def train_model():
    dataset = AuraDataset(
        "data/baseline_data.json", 
        "data/vocal_features.json", 
        "data/linguistic_samples.json"
    )
    dataloader = DataLoader(dataset, batch_size=16, shuffle=True)
    
    model = MultiModalTransformer()
    criterion = nn.MSELoss()
    optimizer = optim.Adam(model.parameters(), lr=0.001)
    
    epochs = 50
    print(f"Starting training for {epochs} epochs...")
    for epoch in range(epochs):
        epoch_loss = 0.0
        for b_feat, v_feat, l_feat, targets in dataloader:
            optimizer.zero_grad()
            outputs = model(b_feat, v_feat, l_feat)
            loss = criterion(outputs, targets)
            loss.backward()
            optimizer.save_step = optimizer.step()
            epoch_loss += loss.item()
            
        if (epoch + 1) % 10 == 0:
            print(f"Epoch {epoch+1}/{epochs}, Loss: {epoch_loss/len(dataloader):.4f}")
            
    print("Training complete. Saving model...")
    torch.save(model.state_dict(), "aura_model.pth")
    print("Model saved to 'aura_model.pth'.")

if __name__ == "__main__":
    train_model()
