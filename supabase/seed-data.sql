-- ============================================
-- Seed Data for Vawmy Curtains
-- ============================================
-- OPTIONAL: Run this after migrations.sql to add sample collections
-- You can skip this if you want to add collections via the admin portal
-- ============================================

-- Clear existing data (optional - comment out if you want to keep existing data)
-- TRUNCATE collections CASCADE;

-- Insert sample collections
INSERT INTO collections (name, description, cover_image, images) VALUES
(
  'Linen Dreams',
  'Experience the light, airy feel of our 100% organic linen curtains. Perfect for creating a calm and natural atmosphere in any room, they offer privacy while gently filtering sunlight.',
  'https://images.pexels.com/photos/3797991/pexels-photo-3797991.jpeg?auto=compress&cs=tinysrgb&w=800&h=1000&dpr=1',
  ARRAY[
    'https://images.pexels.com/photos/1350789/pexels-photo-1350789.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/276583/pexels-photo-276583.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/6758459/pexels-photo-6758459.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/5825577/pexels-photo-5825577.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/4210850/pexels-photo-4210850.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/6585613/pexels-photo-6585613.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
  ]
),
(
  'Velvet Elegance',
  'Indulge in the luxurious texture and rich colors of our velvet collection. These heavyweight curtains provide excellent light blocking and insulation, adding a touch of sophisticated drama.',
  'https://images.pexels.com/photos/6782477/pexels-photo-6782477.jpeg?auto=compress&cs=tinysrgb&w=800&h=1000&dpr=1',
  ARRAY[
    'https://images.pexels.com/photos/7195438/pexels-photo-7195438.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/6625132/pexels-photo-6625132.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/1090638/pexels-photo-1090638.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/6492398/pexels-photo-6492398.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/2251247/pexels-photo-2251247.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/7535058/pexels-photo-7535058.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
  ]
),
(
  'Roman Shades',
  'Discover the tailored elegance of our custom Roman Shades. Offering a clean, modern look, they are perfect for any window, providing both style and excellent light control.',
  'https://images.pexels.com/photos/6489107/pexels-photo-6489107.jpeg?auto=compress&cs=tinysrgb&w=800&h=1000&dpr=1',
  ARRAY[
    'https://images.pexels.com/photos/3932930/pexels-photo-3932930.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/545014/pexels-photo-545014.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/6903138/pexels-photo-6903138.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/5998136/pexels-photo-5998136.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/5998050/pexels-photo-5998050.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/5768307/pexels-photo-5768307.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
  ]
),
(
  'Modern Minimalist',
  'Clean lines and subtle textures define our Modern Minimalist collection. Designed for contemporary spaces, these curtains offer a sleek, understated elegance that complements any decor.',
  'https://images.pexels.com/photos/4352247/pexels-photo-4352247.jpeg?auto=compress&cs=tinysrgb&w=800&h=1000&dpr=1',
  ARRAY[
    'https://images.pexels.com/photos/1454806/pexels-photo-1454806.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/2082092/pexels-photo-2082092.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/370799/pexels-photo-370799.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/271816/pexels-photo-271816.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
  ]
);

-- ============================================
-- Verification
-- ============================================
DO $$
DECLARE
  collection_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO collection_count FROM collections;
  RAISE NOTICE 'Seed data inserted successfully! Total collections: %', collection_count;
END $$;
