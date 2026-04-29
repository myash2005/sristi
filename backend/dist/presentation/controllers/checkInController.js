"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getDemoData = exports.submitCheckIn = void 0;
const models_1 = require("../../infrastructure/database/models");
const services_1 = require("../../application/usecases/services");
const AI_MICROSERVICE_URL = process.env.AI_MICROSERVICE_URL || 'http://localhost:5000/predict';
const submitCheckIn = async (req, res) => {
    try {
        const { caregiverId, typingSpeedWpm, backspaceFrequency, voiceTranscript, vocalEnergyState, baselineData, linguisticData } = req.body;
        if (!caregiverId || !typingSpeedWpm) {
            return res.status(400).json({ error: "Missing required check-in fields." });
        }
        // 1. Passive Detection Engine: Cognitive Load Score
        // High backspace frequency and slow typing = High cognitive load
        const cognitiveLoadScore = Math.min(1.0, (backspaceFrequency * 0.1) + (100 / Math.max(1, typingSpeedWpm)));
        // 2. Fetch Burnout Risk Index from AI Microservice
        let aiStressIndex = 0.5; // Default fallback
        try {
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 5000);
            const aiResponse = await fetch(AI_MICROSERVICE_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    baseline: baselineData || [0.5, 0.5, 0.5, 0.5, 0.5],
                    vocal: [0.5, 0.05, 0.05, 0.5], // Dummy vocal features if not provided
                    linguistic: linguisticData || [0.5, 0.5, 0.0]
                }),
                signal: controller.signal
            });
            clearTimeout(timeoutId);
            const aiResult = await aiResponse.json();
            if (aiResult.status === 'success') {
                aiStressIndex = aiResult.burnout_risk_index;
            }
        }
        catch (aiError) {
            console.error("AI Microservice unreachable. Using fallback stress index.");
        }
        // 3. Privacy-First Encryption
        const encryptedTranscript = services_1.EncryptionService.encrypt(voiceTranscript || "No transcript provided");
        // 4. Save to Database (gracefully skipped if MongoDB is unavailable)
        try {
            const checkIn = new models_1.CheckInModel({
                caregiverId,
                typingSpeedWpm,
                backspaceFrequency,
                cognitiveLoadScore,
                voiceTranscriptEncrypted: encryptedTranscript,
                vocalEnergyState,
                aiStressIndex
            });
            await checkIn.save();
        }
        catch (dbError) {
            console.warn("DB save skipped (MongoDB unavailable):", dbError.message);
        }
        // 5. Agentic Nudge Engine
        // Assuming we fetched User to get distanceFromHospital, using mock distance for demo
        const distanceFromHospitalKm = 15;
        const recommendedNudge = services_1.NudgeEngine.evaluateNudge(aiStressIndex, distanceFromHospitalKm);
        return res.status(200).json({
            message: "Check-in processed successfully",
            data: {
                cognitiveLoadScore,
                aiStressIndex,
                recommendedNudge
            }
        });
    }
    catch (error) {
        console.error("Error processing check-in:", error);
        return res.status(500).json({ error: "An unexpected error occurred while processing the check-in." });
    }
};
exports.submitCheckIn = submitCheckIn;
const getDemoData = async (req, res) => {
    try {
        // Mock Demo Data: Sarah's Journey
        return res.status(200).json({
            caregiver: {
                name: "Sarah",
                age: 42,
                economicStruggleIndex: 0.7, // High stress factor
                distanceFromHospitalKm: 25
            },
            history: [
                { day: "Monday", stressIndex: 0.4, nudge: null },
                { day: "Wednesday", stressIndex: 0.7, nudge: "triggerTakeABreathNudge" },
                { day: "Friday", stressIndex: 0.85, nudge: "triggerRespiteCareNudge" }
            ]
        });
    }
    catch (error) {
        return res.status(500).json({ error: "Failed to load demo data." });
    }
};
exports.getDemoData = getDemoData;
