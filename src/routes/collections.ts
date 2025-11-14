import express from 'express';
import { supabase } from '../config/supabase.js';
import { basicAuth } from '../middleware/auth.js';

const router = express.Router();

// Public routes
router.get('/', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('collections')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;
    res.json(data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('collections')
      .select('*')
      .eq('id', req.params.id)
      .single();

    if (error) throw error;
    res.json(data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// Admin routes
router.post('/', basicAuth, async (req, res) => {
  try {
    const { name, description, cover_image, images } = req.body;
    
    const { data, error } = await supabase
      .from('collections')
      .insert([{ name, description, cover_image, images }])
      .select()
      .single();

    if (error) throw error;
    res.status(201).json(data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

router.put('/:id', basicAuth, async (req, res) => {
  try {
    const { name, description, cover_image, images } = req.body;
    
    const { data, error } = await supabase
      .from('collections')
      .update({ name, description, cover_image, images })
      .eq('id', req.params.id)
      .select()
      .single();

    if (error) throw error;
    res.json(data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

router.delete('/:id', basicAuth, async (req, res) => {
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
