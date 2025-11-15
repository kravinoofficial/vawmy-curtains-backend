import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import collectionsRouter from './routes/collections.js';
import contactRouter from './routes/contact.js';
import uploadRouter from './routes/upload.js';
import videoUploadRouter from './routes/video-upload.js';
import blogRouter from './routes/blog.js';
import socialRouter from './routes/social.js';
import subcategoriesRouter from './routes/subcategories.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

// Configure CORS to allow all origins
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: false
}));

// Handle preflight requests
app.options('*', cors());

app.use(express.json());

app.use('/api/collections', collectionsRouter);
app.use('/api/contact', contactRouter);
app.use('/api/upload', uploadRouter);
app.use('/api/upload-video', videoUploadRouter);
app.use('/api/blog', blogRouter);
app.use('/api/social', socialRouter);
app.use('/api', subcategoriesRouter);

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// For local development
if (process.env.NODE_ENV !== 'production') {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

// Export for Vercel serverless
export default app;
