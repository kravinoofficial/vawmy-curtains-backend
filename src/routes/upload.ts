import express from 'express';
import multer from 'multer';
import sharp from 'sharp';
import { supabase } from '../config/supabase.js';
import { supabaseAuth } from '../middleware/auth.js';

const router = express.Router();
const upload = multer({ 
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 } // 10MB max upload
});

router.post('/', supabaseAuth, upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // Compress and optimize image
    let processedBuffer: Buffer;
    const targetSize = 500 * 1024; // 500KB target
    
    try {
      // Get image metadata
      const metadata = await sharp(req.file.buffer).metadata();
      
      // Calculate dimensions to maintain aspect ratio
      let width = metadata.width || 1920;
      let height = metadata.height || 1080;
      
      // Resize if too large (max 1920px width)
      if (width > 1920) {
        height = Math.round((1920 / width) * height);
        width = 1920;
      }
      
      // Start with quality 85
      let quality = 85;
      processedBuffer = await sharp(req.file.buffer)
        .resize(width, height, { 
          fit: 'inside',
          withoutEnlargement: true 
        })
        .jpeg({ quality, progressive: true })
        .toBuffer();
      
      // If still too large, reduce quality iteratively
      while (processedBuffer.length > targetSize && quality > 60) {
        quality -= 5;
        processedBuffer = await sharp(req.file.buffer)
          .resize(width, height, { 
            fit: 'inside',
            withoutEnlargement: true 
          })
          .jpeg({ quality, progressive: true })
          .toBuffer();
      }
      
      console.log(`Image compressed: ${req.file.size} -> ${processedBuffer.length} bytes (quality: ${quality})`);
      
    } catch (sharpError) {
      console.error('Image processing error:', sharpError);
      return res.status(400).json({ error: 'Invalid image file' });
    }

    // Generate unique filename
    const fileExt = 'jpg'; // Always save as JPEG after compression
    const fileName = `${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`;
    
    // Upload to Supabase Storage
    const { data, error } = await supabase.storage
      .from('collection-images')
      .upload(fileName, processedBuffer, {
        contentType: 'image/jpeg',
        upsert: false,
        cacheControl: '3600'
      });

    if (error) throw error;

    // Get public URL
    const { data: urlData } = supabase.storage
      .from('collection-images')
      .getPublicUrl(fileName);

    res.json({ 
      url: urlData.publicUrl,
      size: processedBuffer.length,
      originalSize: req.file.size
    });
  } catch (error: any) {
    console.error('Upload error:', error);
    res.status(500).json({ error: error.message });
  }
});

export default router;
