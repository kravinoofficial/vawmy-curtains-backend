import { Router, Request, Response } from 'express';
import { supabase } from '../config/supabase.js';
import { supabaseAuth } from '../middleware/auth.js';
import multer from 'multer';
import sharp from 'sharp';
import path from 'path';
import fs from 'fs';

const router = Router();
const upload = multer({ dest: 'uploads/' });

// Get all blog posts
router.get('/', async (req: Request, res: Response) => {
  try {
    const { data, error } = await supabase
      .from('blog_posts')
      .select('*')
      .order('published_date', { ascending: false });

    if (error) throw error;

    res.json(data);
  } catch (error) {
    console.error('Error fetching blog posts:', error);
    res.status(500).json({ error: 'Failed to fetch blog posts' });
  }
});

// Get single blog post by slug
router.get('/:slug', async (req: Request, res: Response) => {
  try {
    const { slug } = req.params;
    
    const { data, error } = await supabase
      .from('blog_posts')
      .select('*')
      .eq('slug', slug)
      .single();

    if (error) throw error;

    res.json(data);
  } catch (error) {
    console.error('Error fetching blog post:', error);
    res.status(404).json({ error: 'Blog post not found' });
  }
});

// Create new blog post
router.post('/', supabaseAuth, upload.single('cover_image'), async (req: Request, res: Response) => {
  try {
    const { title, slug, excerpt, content, author } = req.body;
    let coverImageUrl = req.body.cover_image_url || '';

    // Handle image upload if file is provided
    if (req.file) {
      const fileName = `blog-${Date.now()}.jpg`;
      const outputPath = path.join('uploads', fileName);

      await sharp(req.file.path)
        .resize(1200, 630, { fit: 'cover' })
        .jpeg({ quality: 85 })
        .toFile(outputPath);

      const fileBuffer = fs.readFileSync(outputPath);
      const { data: uploadData, error: uploadError } = await supabase.storage
        .from('images')
        .upload(fileName, fileBuffer, {
          contentType: 'image/jpeg',
          upsert: false
        });

      if (uploadError) throw uploadError;

      const { data: { publicUrl } } = supabase.storage
        .from('images')
        .getPublicUrl(fileName);

      coverImageUrl = publicUrl;

      fs.unlinkSync(req.file.path);
      fs.unlinkSync(outputPath);
    }

    const { data, error } = await supabase
      .from('blog_posts')
      .insert([{
        title,
        slug,
        excerpt,
        content,
        cover_image: coverImageUrl,
        author: author || 'Vawmy Team'
      }])
      .select()
      .single();

    if (error) throw error;

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating blog post:', error);
    res.status(500).json({ error: 'Failed to create blog post' });
  }
});

// Update blog post
router.put('/:id', supabaseAuth, upload.single('cover_image'), async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { title, slug, excerpt, content, author } = req.body;
    let updateData: any = {
      title,
      slug,
      excerpt,
      content,
      author,
      updated_at: new Date().toISOString()
    };

    // Handle image upload if file is provided
    if (req.file) {
      const fileName = `blog-${Date.now()}.jpg`;
      const outputPath = path.join('uploads', fileName);

      await sharp(req.file.path)
        .resize(1200, 630, { fit: 'cover' })
        .jpeg({ quality: 85 })
        .toFile(outputPath);

      const fileBuffer = fs.readFileSync(outputPath);
      const { data: uploadData, error: uploadError } = await supabase.storage
        .from('images')
        .upload(fileName, fileBuffer, {
          contentType: 'image/jpeg',
          upsert: false
        });

      if (uploadError) throw uploadError;

      const { data: { publicUrl } } = supabase.storage
        .from('images')
        .getPublicUrl(fileName);

      updateData.cover_image = publicUrl;

      fs.unlinkSync(req.file.path);
      fs.unlinkSync(outputPath);
    } else if (req.body.cover_image_url) {
      updateData.cover_image = req.body.cover_image_url;
    }

    const { data, error } = await supabase
      .from('blog_posts')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    res.json(data);
  } catch (error) {
    console.error('Error updating blog post:', error);
    res.status(500).json({ error: 'Failed to update blog post' });
  }
});

// Delete blog post
router.delete('/:id', supabaseAuth, async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const { error } = await supabase
      .from('blog_posts')
      .delete()
      .eq('id', id);

    if (error) throw error;

    res.json({ message: 'Blog post deleted successfully' });
  } catch (error) {
    console.error('Error deleting blog post:', error);
    res.status(500).json({ error: 'Failed to delete blog post' });
  }
});

export default router;
