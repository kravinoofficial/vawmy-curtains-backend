import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import collectionsRouter from './routes/collections.js';
import contactRouter from './routes/contact.js';
import uploadRouter from './routes/upload.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.use('/api/collections', collectionsRouter);
app.use('/api/contact', contactRouter);
app.use('/api/upload', uploadRouter);

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
