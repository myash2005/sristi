import torch
import torch.nn as nn
import torch.nn.functional as F

class MultiModalTransformer(nn.Module):
    def __init__(self, baseline_dim=5, vocal_dim=4, linguistic_dim=3, hidden_dim=64, num_heads=4, num_layers=2):
        super(MultiModalTransformer, self).__init__()
        
        # Linear layers to project inputs to the same hidden dimension
        self.baseline_proj = nn.Linear(baseline_dim, hidden_dim)
        self.vocal_proj = nn.Linear(vocal_dim, hidden_dim)
        self.linguistic_proj = nn.Linear(linguistic_dim, hidden_dim)
        
        # Transformer Encoder Layer
        encoder_layer = nn.TransformerEncoderLayer(d_model=hidden_dim, nhead=num_heads, batch_first=True)
        self.transformer_encoder = nn.TransformerEncoder(encoder_layer, num_layers=num_layers)
        
        # Fully connected layers for output
        self.fc1 = nn.Linear(hidden_dim, 32)
        self.fc2 = nn.Linear(32, 1) # Burnout Risk Index (0 to 1)

    def forward(self, baseline, vocal, linguistic):
        # Project inputs
        b_proj = self.baseline_proj(baseline).unsqueeze(1) # (batch, 1, hidden_dim)
        v_proj = self.vocal_proj(vocal).unsqueeze(1) # (batch, 1, hidden_dim)
        l_proj = self.linguistic_proj(linguistic).unsqueeze(1) # (batch, 1, hidden_dim)
        
        # Concatenate modalities as a sequence
        # Shape: (batch, 3, hidden_dim)
        sequence = torch.cat([b_proj, v_proj, l_proj], dim=1)
        
        # Pass through Transformer
        transformer_out = self.transformer_encoder(sequence) # (batch, 3, hidden_dim)
        
        # Aggregate output (e.g., mean pooling across sequence)
        pooled_out = torch.mean(transformer_out, dim=1) # (batch, hidden_dim)
        
        # Feed-forward network
        x = F.relu(self.fc1(pooled_out))
        output = torch.sigmoid(self.fc2(x)) # Bound between 0 and 1
        
        return output

if __name__ == "__main__":
    # Test model
    model = MultiModalTransformer()
    b = torch.randn(10, 5)
    v = torch.randn(10, 4)
    l = torch.randn(10, 3)
    out = model(b, v, l)
    print("Model output shape:", out.shape)
