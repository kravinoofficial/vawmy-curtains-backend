-- ============================================
-- Storage Policies for collection-images bucket
-- ============================================
-- IMPORTANT: Run this AFTER creating the 'collection-images' bucket
-- and making it PUBLIC in the Supabase dashboard
-- ============================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can read images" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can upload images" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can update images" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can delete images" ON storage.objects;

-- ============================================
-- Public read access
-- ============================================
CREATE POLICY "Public can read images"
ON storage.objects 
FOR SELECT
USING (bucket_id = 'collection-images');

-- ============================================
-- Allow uploads (no auth required - backend handles it)
-- ============================================
CREATE POLICY "Anyone can upload images"
ON storage.objects 
FOR INSERT
WITH CHECK (bucket_id = 'collection-images');

-- ============================================
-- Allow updates
-- ============================================
CREATE POLICY "Anyone can update images"
ON storage.objects 
FOR UPDATE
USING (bucket_id = 'collection-images')
WITH CHECK (bucket_id = 'collection-images');

-- ============================================
-- Allow deletes
-- ============================================
CREATE POLICY "Anyone can delete images"
ON storage.objects 
FOR DELETE
USING (bucket_id = 'collection-images');

-- ============================================
-- Verification
-- ============================================
DO $$
BEGIN
  -- Check if bucket exists
  IF NOT EXISTS (
    SELECT 1 FROM storage.buckets WHERE id = 'collection-images'
  ) THEN
    RAISE WARNING 'Bucket "collection-images" does not exist. Please create it first!';
  ELSE
    RAISE NOTICE 'Storage policies created successfully for collection-images bucket!';
  END IF;
END $$;
