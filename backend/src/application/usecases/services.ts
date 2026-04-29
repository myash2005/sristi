import crypto from 'crypto';

// Use Case: Privacy-First Encryption (AES-256)
export class EncryptionService {
    private static algorithm = 'aes-256-cbc';
    private static key = crypto.scryptSync(
        process.env.ENCRYPTION_SECRET || 'aura-secret-key',
        process.env.ENCRYPTION_SALT || 'aura-salt',
        32
    );
    
    public static encrypt(text: string): string {
        const iv = crypto.randomBytes(16);
        const cipher = crypto.createCipheriv(this.algorithm, this.key, iv);
        let encrypted = cipher.update(text, 'utf8', 'hex');
        encrypted += cipher.final('hex');
        return iv.toString('hex') + ':' + encrypted;
    }

    public static decrypt(text: string): string {
        const textParts = text.split(':');
        const iv = Buffer.from(textParts.shift()!, 'hex');
        const encryptedText = Buffer.from(textParts.join(':'), 'hex');
        const decipher = crypto.createDecipheriv(this.algorithm, this.key, iv);
        let decrypted = decipher.update(encryptedText);
        decrypted = Buffer.concat([decrypted, decipher.final()]);
        return decrypted.toString();
    }
}

// Use Case: Agentic Nudge Engine
export class NudgeEngine {
    public static evaluateNudge(stressIndex: number, distanceFromHospitalKm: number): string | null {
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
