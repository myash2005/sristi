"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.NudgeEngine = exports.EncryptionService = void 0;
const crypto_1 = __importDefault(require("crypto"));
// Use Case: Privacy-First Encryption (AES-256)
class EncryptionService {
    static algorithm = 'aes-256-cbc';
    static key = crypto_1.default.scryptSync(process.env.ENCRYPTION_SECRET || 'aura-secret-key', process.env.ENCRYPTION_SALT || 'aura-salt', 32);
    static encrypt(text) {
        const iv = crypto_1.default.randomBytes(16);
        const cipher = crypto_1.default.createCipheriv(this.algorithm, this.key, iv);
        let encrypted = cipher.update(text, 'utf8', 'hex');
        encrypted += cipher.final('hex');
        return iv.toString('hex') + ':' + encrypted;
    }
    static decrypt(text) {
        const textParts = text.split(':');
        const iv = Buffer.from(textParts.shift(), 'hex');
        const encryptedText = Buffer.from(textParts.join(':'), 'hex');
        const decipher = crypto_1.default.createDecipheriv(this.algorithm, this.key, iv);
        let decrypted = decipher.update(encryptedText);
        decrypted = Buffer.concat([decrypted, decipher.final()]);
        return decrypted.toString();
    }
}
exports.EncryptionService = EncryptionService;
// Use Case: Agentic Nudge Engine
class NudgeEngine {
    static evaluateNudge(stressIndex, distanceFromHospitalKm) {
        // Rule-Based Trigger System
        if (stressIndex > 0.8 && distanceFromHospitalKm > 10) {
            return "triggerRespiteCareNudge";
        }
        if (stressIndex > 0.6) {
            return "triggerTakeABreathNudge";
        }
        if (stressIndex > 0.4) {
            return "triggerHydrationNudge";
        }
        return null;
    }
}
exports.NudgeEngine = NudgeEngine;
