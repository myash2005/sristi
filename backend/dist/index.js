"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const mongoose_1 = __importDefault(require("mongoose"));
const path_1 = __importDefault(require("path"));
const checkInController_1 = require("./presentation/controllers/checkInController");
dotenv_1.default.config();
const app = (0, express_1.default)();
const PORT = process.env.PORT || 3000;
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Routes
app.post('/api/checkin', checkInController_1.submitCheckIn);
app.get('/api/demo', checkInController_1.getDemoData);
// Serve React frontend
app.use(express_1.default.static(path_1.default.join(__dirname, '../public')));
app.get('*', (_req, res) => res.sendFile(path_1.default.join(__dirname, '../public/index.html')));
// Basic error handler
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Something went wrong!' });
});
// Database connection (Mocked for demo purposes, will not crash if Mongo is not running)
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/aura';
mongoose_1.default.connect(MONGO_URI, { serverSelectionTimeoutMS: 3000, bufferCommands: false })
    .then(() => console.log('MongoDB connected'))
    .catch(err => console.error('MongoDB connection error. Starting without DB persistence.', err.message));
app.listen(PORT, () => {
    console.log(`Aura Backend is running on http://localhost:${PORT}`);
});
