import json
import random
import os

def generate_baseline_data(num_samples=100):
    data = []
    for i in range(num_samples):
        # 32 factors (simplified for demo to key factors)
        economic_factor = random.uniform(0, 1) # 0 is wealthy, 1 is struggling
        geo_distance = random.uniform(0, 100) # km from hospital
        
        # Correlating economic factor and distance with higher baseline stress
        base_stress = 0.2 + (economic_factor * 0.4) + (min(geo_distance, 50) / 50 * 0.3)
        base_stress = min(1.0, base_stress + random.uniform(-0.1, 0.1))
        
        data.append({
            "caregiver_id": f"cg_{i}",
            "age": random.randint(25, 65),
            "economic_struggle_index": round(economic_factor, 2),
            "distance_from_hospital_km": round(geo_distance, 2),
            "hours_caregiving_per_week": random.randint(10, 80),
            "support_system_strength": random.uniform(0, 1),
            "baseline_stress_weight": round(base_stress, 4)
        })
    return data

def generate_vocal_features(num_samples=100):
    data = []
    states = ["Vitality", "Fatigue", "Burnout"]
    for i in range(num_samples):
        state = random.choice(states)
        
        if state == "Vitality":
            pitch = random.uniform(180, 220)
            jitter = random.uniform(0.01, 0.03)
            shimmer = random.uniform(0.02, 0.05)
            pause_duration = random.uniform(0.1, 0.3)
        elif state == "Fatigue":
            pitch = random.uniform(150, 180)
            jitter = random.uniform(0.03, 0.06)
            shimmer = random.uniform(0.05, 0.08)
            pause_duration = random.uniform(0.3, 0.6)
        else: # Burnout
            pitch = random.uniform(130, 150)
            jitter = random.uniform(0.06, 0.1)
            shimmer = random.uniform(0.08, 0.15)
            pause_duration = random.uniform(0.6, 1.2)
            
        data.append({
            "sample_id": f"vf_{i}",
            "pitch_hz": round(pitch, 2),
            "jitter_percent": round(jitter, 4),
            "shimmer_percent": round(shimmer, 4),
            "pause_duration_s": round(pause_duration, 2),
            "energy_state_label": state
        })
    return data

def generate_linguistic_samples(num_samples=100):
    data = []
    for i in range(num_samples):
        is_masked_distress = random.random() < 0.2
        
        if is_masked_distress:
            text = "Everything is completely fine. I'm doing great... just... perfectly fine."
            fragmentation_score = 0.8
            sentiment_score = 0.9 # High positive words
            true_distress = 0.9
        else:
            is_distressed = random.random() < 0.3
            if is_distressed:
                text = "I am feeling so overwhelmed today. It's too much."
                fragmentation_score = 0.4
                sentiment_score = 0.2
                true_distress = 0.8
            else:
                text = "We had a good day today. Feeling rested."
                fragmentation_score = 0.1
                sentiment_score = 0.8
                true_distress = 0.1
                
        data.append({
            "sample_id": f"ls_{i}",
            "text": text,
            "syntax_fragmentation_score": fragmentation_score,
            "lexical_sentiment_score": sentiment_score,
            "is_masked_distress": is_masked_distress,
            "true_distress_level": true_distress
        })
    return data

def generate_intervention_logs(num_samples=100):
    data = []
    nudges = ["take_a_breath", "call_support_hotline", "respite_care_suggestion", "drink_water"]
    for i in range(num_samples):
        nudge = random.choice(nudges)
        pre_stress = random.uniform(0.5, 1.0)
        
        if nudge == "respite_care_suggestion" and pre_stress > 0.8:
            post_stress = pre_stress - random.uniform(0.2, 0.4)
        elif nudge == "take_a_breath":
            post_stress = pre_stress - random.uniform(0.05, 0.15)
        else:
            post_stress = pre_stress - random.uniform(0.0, 0.1)
            
        data.append({
            "log_id": f"il_{i}",
            "nudge_type": nudge,
            "pre_intervention_stress": round(pre_stress, 4),
            "post_intervention_stress": round(post_stress, 4),
            "stress_reduction": round(pre_stress - post_stress, 4)
        })
    return data

if __name__ == "__main__":
    os.makedirs("data", exist_ok=True)
    
    with open("data/baseline_data.json", "w") as f:
        json.dump(generate_baseline_data(), f, indent=2)
        
    with open("data/vocal_features.json", "w") as f:
        json.dump(generate_vocal_features(), f, indent=2)
        
    with open("data/linguistic_samples.json", "w") as f:
        json.dump(generate_linguistic_samples(), f, indent=2)
        
    with open("data/intervention_logs.json", "w") as f:
        json.dump(generate_intervention_logs(), f, indent=2)
        
    print("Synthetic datasets generated successfully in 'data' directory.")
