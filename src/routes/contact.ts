import express from 'express';
import { supabase } from '../config/supabase.js';
import { supabaseAuth } from '../middleware/auth.js';

const router = express.Router();

// Public route
router.get('/', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('contact_info')
      .select('*')
      .single();

    if (error) throw error;
    res.json(data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

// Admin route
router.put('/', supabaseAuth, async (req, res) => {
  try {
    const { email, phone, address, hours } = req.body;
    
    const { data, error } = await supabase
      .from('contact_info')
      .upsert({ id: 1, email, phone, address, hours })
      .select()
      .single();

    if (error) throw error;
    res.json(data);
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
