import express from 'express';
import multer from 'multer';
import { supabase } from '../config/supabase.js';
import { supabaseAuth } from '../middleware/auth.js';

const router = express.Router();
const upload = multer({ 
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB max
  fileFilter: (req, file, cb) => {
    // Accept video files only
    if (file.mimetype.startsWith('video/')) {
      cb(null, true);
    } else {
      cb(new Error('Only video files are allowed'));
    }
  }
});

router.post('/', supabaseAuth, upload.single('video'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No video file uploaded' });
    }

    // Generate unique filename
    const fileExt = req.file.originalname.split('.').pop();
    const fileName = `${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`;
    
    // Upload to Supabase Storage
    const { data, error } = await supabase.storage
      .from('collection-videos')
      .upload(fileName, req.file.buffer, {
        contentType: req.file.mimetype,
        upsert: false,
        cacheControl: '3600'
      });

    if (error) throw error;

    // Get public URL
    const { data: urlData } = supabase.storage
      .from('collection-videos')
      .getPublicUrl(fileName);

    res.json({ 
      url: urlData.publicUrl,
      size: req.file.size
    });
  } catch (error: any) {
    console.error('Video upload error:', error);
    res.status(500).json({ error: error.message });
  }
});

export default router;
