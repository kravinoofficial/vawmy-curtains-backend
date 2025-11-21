import { Router, Request, Response } from 'express';
import { supabase } from '../config/supabase.js';
import { supabaseAuth } from '../middleware/auth.js';

const router = Router();

// Get all subcategories for a collection
router.get('/collections/:collectionId/subcategories', async (req: Request, res: Response) => {
  try {
    const { collectionId } = req.params;
    
    const { data, error } = await supabase
      .from('subcategories')
      .select('*')
      .eq('collection_id', collectionId)
      .order('display_order', { ascending: true });

    if (error) throw error;

    res.json(data);
  } catch (error) {
    console.error('Error fetching subcategories:', error);
    res.status(500).json({ error: 'Failed to fetch subcategories' });
  }
});

// Create new subcategory
router.post('/subcategories', supabaseAuth, async (req: Request, res: Response) => {
  try {
    const { collection_id, name, images, display_order } = req.body;

    // Validate max 5 images
    if (images && images.length > 5) {
      return res.status(400).json({ error: 'Maximum 5 images allowed per subcategory' });
    }

    const { data, error } = await supabase
      .from('subcategories')
      .insert([{
        collection_id,
        name,
        images: images || [],
        display_order: display_order || 0
      }])
      .select()
      .single();

    if (error) throw error;

    res.status(201).json(data);
  } catch (error) {
    console.error('Error creating subcategory:', error);
    res.status(500).json({ error: 'Failed to create subcategory' });
  }
});

// Update subcategory
router.put('/subcategories/:id', supabaseAuth, async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { name, images, display_order } = req.body;

    // Validate max 5 images
    if (images && images.length > 5) {
      return res.status(400).json({ error: 'Maximum 5 images allowed per subcategory' });
    }

    const updateData: any = {
      updated_at: new Date().toISOString()
    };

    if (name !== undefined) updateData.name = name;
    if (images !== undefined) updateData.images = images;
    if (display_order !== undefined) updateData.display_order = display_order;

    const { data, error } = await supabase
      .from('subcategories')
      .update(updateData)
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    res.json(data);
  } catch (error) {
    console.error('Error updating subcategory:', error);
    res.status(500).json({ error: 'Failed to update subcategory' });
  }
});

// Delete subcategory
router.delete('/subcategories/:id', supabaseAuth, async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const { error } = await supabase
      .from('subcategories')
      .delete()
      .eq('id', id);

    if (error) throw error;

    res.json({ message: 'Subcategory deleted successfully' });
  } catch (error) {
    console.error('Error deleting subcategory:', error);
    res.status(500).json({ error: 'Failed to delete subcategory' });
  }
});

export default router;
