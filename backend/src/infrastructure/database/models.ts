import mongoose, { Schema, Document } from 'mongoose';

// User (32 Factors - Simplified for demo)
export interface IUser extends Document {
    caregiverId: string;
    age: number;
    economicStruggleIndex: number;
    distanceFromHospitalKm: number;
    hoursCaregivingPerWeek: number;
    supportSystemStrength: number;
    baselineStressWeight: number;
}

const UserSchema: Schema = new Schema({
    caregiverId: { type: String, required: true, unique: true },
    age: { type: Number, required: true },
    economicStruggleIndex: { type: Number, required: true },
    distanceFromHospitalKm: { type: Number, required: true },
    hoursCaregivingPerWeek: { type: Number, required: true },
    supportSystemStrength: { type: Number, required: true },
    baselineStressWeight: { type: Number, required: true }
});

export const UserModel = mongoose.model<IUser>('User', UserSchema);

// Check-in Log (8 Questions + Dynamic Data)
export interface ICheckIn extends Document {
    caregiverId: string;
    timestamp: Date;
    typingSpeedWpm: number;
    backspaceFrequency: number;
    cognitiveLoadScore: number;
    voiceTranscriptEncrypted: string;
    vocalEnergyState: string;
    aiStressIndex: number;
}

const CheckInSchema: Schema = new Schema({
    caregiverId: { type: String, required: true },
    timestamp: { type: Date, default: Date.now },
    typingSpeedWpm: { type: Number, required: true },
    backspaceFrequency: { type: Number, required: true },
    cognitiveLoadScore: { type: Number, required: true },
    voiceTranscriptEncrypted: { type: String, required: true },
    vocalEnergyState: { type: String, required: true },
    aiStressIndex: { type: Number, required: true }
});

export const CheckInModel = mongoose.model<ICheckIn>('CheckIn', CheckInSchema);
