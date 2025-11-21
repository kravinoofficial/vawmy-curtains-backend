import express from 'express';
import { supabase } from '../config/supabase.js';
import { supabaseAuth } from '../middleware/auth.js';

const router = express.Router();

// Public routes
router.get('/', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('collections')
      .select('*')
      .order('display_order', { ascending: true })
      .order('created_at', { ascending: false });

    if (error) throw error;
    res.json(data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    // Get collection with subcategories
    const { data: collection, error: collectionError } = await supabase
      .from('collections')
      .select('*')
      .eq('id', req.params.id)
      .single();

    if (collectionError) throw collectionError;

    // Get subcategories for this collection
    const { data: subcategories, error: subcategoriesError } = await supabase
      .from('subcategories')
      .select('*')
      .eq('collection_id', req.params.id)
      .order('display_order', { ascending: true });

    if (subcategoriesError) throw subcategoriesError;

    res.json({ ...collection, subcategories });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// Admin routes
router.post('/', supabaseAuth, async (req, res) => {
  try {
    const { name, description, cover_image, images, video_url, display_order } = req.body;
    
    const { data, error } = await supabase
      .from('collections')
      .insert([{ 
        name, 
        description, 
        cover_image, 
        images,
        video_url: video_url || null,
        display_order: display_order || 0
      }])
      .select()
      .single();

    if (error) throw error;
    res.status(201).json(data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

router.put('/:id', supabaseAuth, async (req, res) => {
  try {
    const { name, description, cover_image, images, video_url, display_order } = req.body;
    
    const updateData: any = {
      updated_at: new Date().toISOString()
    };
    
    if (name !== undefined) updateData.name = name;
    if (description !== undefined) updateData.description = description;
    if (cover_image !== undefined) updateData.cover_image = cover_image;
    if (images !== undefined) updateData.images = images;
    if (video_url !== undefined) updateData.video_url = video_url;
    if (display_order !== undefined) updateData.display_order = display_order;
    
    const { data, error } = await supabase
      .from('collections')
      .update(updateData)
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) throw error;
    res.json(data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

router.delete('/:id', supabaseAuth, async (req, res) => {
  try {
    const { error } = await supabase
      .from('collections')
      .delete()
      .eq('id', req.params.id);

    if (error) throw error;
    res.json({ message: 'Collection deleted successfully' });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
