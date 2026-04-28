# Aura: Caregiver Health-Tech System

Aura is a caregiver-centered system designed to detect and mitigate burnout risk through technical perfection, high-fidelity UI, and deep emotional intelligence. This repository contains the complete modular architecture, spanning from the Flutter frontend to the Node.js backend and the Python Multi-Modal AI microservice.

## Mathematical Correlation: 32 Baseline Factors & Burnout Detection

Aura calculates a **Burnout Risk Index** (`R`) ranging from 0.0 to 1.0. The AI engine uses a Multi-Modal Transformer that fuses three distinct data streams:
1. **Baseline Static Factors** ($B$)
2. **Vocal Acoustic Features** ($V$)
3. **Linguistic Check-in Data** ($L$)

### 1. The Baseline Vector ($B$)
The registration data comprises 32 static factors. For model simplicity, we compress these into 5 core dimensions $D_i$:
- $D_1$: Age/Demographic Strain
- $D_2$: Economic Struggle Index
- $D_3$: Distance from Hospital (km)
- $D_4$: Hours Caregiving per Week
- $D_5$: Support System Strength (Inverse)

The unweighted baseline stress ($S_{base}$) is highly correlated with economic factors and geographical distance. The mathematical correlation is approximated as:
$$ S_{base} = \alpha(D_2) + \beta(\min(D_3, 50)/50) + \gamma(D_4) - \delta(D_5) $$
Where $\alpha=0.4$ and $\beta=0.3$. This creates a heavily weighted baseline pre-disposition to burnout based on socio-economic realities.

### 2. Multi-Modal Transformer Fusion
The Transformer processes sequences of modalities:
$$ H = \text{TransformerEncoder}(\text{Concat}(W_b B, W_v V, W_l L)) $$
The Output Burnout Risk ($R$) is a sigmoid activation over the pooled hidden states:
$$ R = \sigma(W_{out} \cdot \text{MeanPool}(H) + b) $$

By training this model on our synthetic "Intervention Logs" (Dataset 4), the model learns that *Masked Distress* (e.g., high positive sentiment but high syntax fragmentation in Dataset 3) combined with high *Economic Struggle* ($D_2$) yields a significantly higher $R$ value.

## System Architecture

### 1. Frontend (Flutter)
- **State Management**: Built using BLoC pattern for zero-crash reliability.
- **Passive Detection**: Calculates a Cognitive Load Score in real-time based on `wpm` and `backspaceRatio`.
  $$ \text{Load Score} = (0.6 \times \text{Backspace Ratio}) + 0.4 \times (1 - \min(1, \frac{\text{WPM}}{60})) $$
- **Aura UI**: Uses `CustomPaint` to render a fluid, morphing gradient. The color temperature and fluid wave velocity are mathematically bound to the $R$ value.

### 2. Backend (Node.js + TypeScript)
- **Clean Architecture**: Decoupled `Entities`, `UseCases`, and `Controllers`.
- **Agentic Nudge Engine**: Evaluates $R$ and environmental factors to trigger micro-nudges:
  `if (stressIndex > 0.8 && distFromHospital > 10km) -> triggerRespiteCareNudge()`
- **Privacy**: Implements AES-256 for Journal transcripts before MongoDB storage.
- **Reliability**: Strict Try-Catch error handling across all API controllers, ensuring 0 null pointer crashes.

### 3. AI Microservice (Python)
- **Flask REST API**: Serves the PyTorch model output.
- **Datasets**: Synthetic datasets modeling vocal jitter/shimmer and linguistic masked distress.

## How to Run

### Frontend
1. Navigate to `frontend/`
2. Run `flutter pub get`
3. Run `flutter run`

### Backend
1. Navigate to `backend/`
2. Run `npm install`
3. Run `npm run build`
4. Run `npm start`

### AI Microservice
1. Navigate to `ai_microservice/`
2. Install requirements: `pip install torch flask numpy`
3. Generate synthetic data: `python data_generator.py`
4. Train the model: `python train.py`
5. Start the server: `python app.py`
