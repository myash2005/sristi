import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import mongoose from 'mongoose';
import path from 'path';
import { submitCheckIn, getDemoData } from './presentation/controllers/checkInController';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Routes
app.post('/api/checkin', submitCheckIn);
app.get('/api/demo', getDemoData);

// Serve React frontend
app.use(express.static(path.join(__dirname, '../public')));
app.get('*', (_req, res) => res.sendFile(path.join(__dirname, '../public/index.html')));

// Basic error handler
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Something went wrong!' });
});

// Database connection (Mocked for demo purposes, will not crash if Mongo is not running)
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/aura';
mongoose.connect(MONGO_URI, { serverSelectionTimeoutMS: 3000, bufferCommands: false })
    .then(() => console.log('MongoDB connected'))
    .catch(err => console.error('MongoDB connection error. Starting without DB persistence.', err.message));

app.listen(PORT, () => {
    console.log(`Aura Backend is running on http://localhost:${PORT}`);
});
