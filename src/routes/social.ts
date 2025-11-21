import { Router, Request, Response } from 'express';
import { supabase } from '../config/supabase.js';
import { supabaseAuth } from '../middleware/auth.js';

const router = Router();

// Get all social media links (public)
router.get('/', async (req: Request, res: Response) => {
  try {
    const { data, error } = await supabase
      .from('social_media')
      .select('*')
      .order('display_order', { ascending: true });

    if (error) throw error;

    res.json(data);
  } catch (error) {
    console.error('Error fetching social media:', error);
    res.status(500).json({ error: 'Failed to fetch social media links' });
  }
});

// Get visible social media links only (public)
router.get('/visible', async (req: Request, res: Response) => {
  try {
    const { data, error } = await supabase
      .from('social_media')
      .select('*')
      .eq('is_visible', true)
      .order('display_order', { ascending: true });

    if (error) throw error;

    res.json(data);
  } catch (error) {
    console.error('Error fetching visible social media:', error);
    res.status(500).json({ error: 'Failed to fetch social media links' });
  }
});

// Create new social media link (admin)
router.post('/', supabaseAuth, async (req: Request, res: Response) => {
  try {
    const { platform, url, icon_name, is_visible, display_order } = req.body;

    const { data, error } = await supabase
      .from('social_media')
      .insert([{
        platform,
        url,
        icon_name,
        is_visible: is_visible !== undefined ? is_visible : true,
        display_order: display_order || 0
      }])
      .select()
      .single();

    if (error) throw error;

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating social media:', error);
    res.status(500).json({ error: 'Failed to create social media link' });
  }
});

// Update social media link (admin)
router.put('/:id', supabaseAuth, async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { platform, url, icon_name, is_visible, display_order } = req.body;

    const updateData: any = {
      updated_at: new Date().toISOString()
    };

    if (platform !== undefined) updateData.platform = platform;
    if (url !== undefined) updateData.url = url;
    if (icon_name !== undefined) updateData.icon_name = icon_name;
    if (is_visible !== undefined) updateData.is_visible = is_visible;
    if (display_order !== undefined) updateData.display_order = display_order;

    const { data, error } = await supabase
      .from('social_media')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    res.json(data);
  } catch (error) {
    console.error('Error updating social media:', error);
    res.status(500).json({ error: 'Failed to update social media link' });
  }
});

// Delete social media link (admin)
router.delete('/:id', supabaseAuth, async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const { error } = await supabase
      .from('social_media')
      .delete()
      .eq('id', id);

    if (error) throw error;

    res.json({ message: 'Social media link deleted successfully' });
  } catch (error) {
    console.error('Error deleting social media:', error);
    res.status(500).json({ error: 'Failed to delete social media link' });
  }
});

export default router;
