-- ============================================
-- Supabase Storage Buckets Setup
-- ============================================

-- Create collection-images bucket (for images)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'collection-images', 
  'collection-images', 
  true,
  10485760, -- 10MB
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 10485760,
  allowed_mime_types = ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif'];

-- Create collection-videos bucket (for videos)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'collection-videos', 
  'collection-videos', 
  true,
  10485760, -- 10MB
  ARRAY['video/mp4', 'video/webm', 'video/ogg', 'video/quicktime']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 10485760,
  allowed_mime_types = ARRAY['video/mp4', 'video/webm', 'video/ogg', 'video/quicktime'];

-- Create images bucket (for blog/other images)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'images', 
  'images', 
  true,
  10485760, -- 10MB
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif']
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 10485760,
  allowed_mime_types = ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif'];

-- Set up storage policies for collection-images
DROP POLICY IF EXISTS "Public Access to collection-images" ON storage.objects;
CREATE POLICY "Public Access to collection-images"
ON storage.objects FOR SELECT
USING (bucket_id = 'collection-images');

DROP POLICY IF EXISTS "Anyone can upload to collection-images" ON storage.objects;
CREATE POLICY "Anyone can upload to collection-images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'collection-images');

DROP POLICY IF EXISTS "Anyone can update collection-images" ON storage.objects;
CREATE POLICY "Anyone can update collection-images"
ON storage.objects FOR UPDATE
USING (bucket_id = 'collection-images');

DROP POLICY IF EXISTS "Anyone can delete from collection-images" ON storage.objects;
CREATE POLICY "Anyone can delete from collection-images"
ON storage.objects FOR DELETE
USING (bucket_id = 'collection-images');

-- Set up storage policies for collection-videos
DROP POLICY IF EXISTS "Public Access to collection-videos" ON storage.objects;
CREATE POLICY "Public Access to collection-videos"
ON storage.objects FOR SELECT
USING (bucket_id = 'collection-videos');

DROP POLICY IF EXISTS "Anyone can upload to collection-videos" ON storage.objects;
CREATE POLICY "Anyone can upload to collection-videos"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'collection-videos');

DROP POLICY IF EXISTS "Anyone can update collection-videos" ON storage.objects;
CREATE POLICY "Anyone can update collection-videos"
ON storage.objects FOR UPDATE
USING (bucket_id = 'collection-videos');

DROP POLICY IF EXISTS "Anyone can delete from collection-videos" ON storage.objects;
CREATE POLICY "Anyone can delete from collection-videos"
ON storage.objects FOR DELETE
USING (bucket_id = 'collection-videos');

-- Set up storage policies for images
DROP POLICY IF EXISTS "Public Access to images" ON storage.objects;
CREATE POLICY "Public Access to images"
ON storage.objects FOR SELECT
USING (bucket_id = 'images');

DROP POLICY IF EXISTS "Anyone can upload to images" ON storage.objects;
CREATE POLICY "Anyone can upload to images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'images');

DROP POLICY IF EXISTS "Anyone can update images" ON storage.objects;
CREATE POLICY "Anyone can update images"
ON storage.objects FOR UPDATE
USING (bucket_id = 'images');

DROP POLICY IF EXISTS "Anyone can delete from images" ON storage.objects;
CREATE POLICY "Anyone can delete from images"
ON storage.objects FOR DELETE
USING (bucket_id = 'images');

-- Verification
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM storage.buckets WHERE id = 'collection-images') THEN
    RAISE NOTICE 'collection-images bucket exists ✓';
  ELSE
    RAISE EXCEPTION 'collection-images bucket not found!';
  END IF;

  IF EXISTS (SELECT 1 FROM storage.buckets WHERE id = 'collection-videos') THEN
    RAISE NOTICE 'collection-videos bucket exists ✓';
  ELSE
    RAISE EXCEPTION 'collection-videos bucket not found!';
  END IF;

  IF EXISTS (SELECT 1 FROM storage.buckets WHERE id = 'images') THEN
    RAISE NOTICE 'images bucket exists ✓';
  ELSE
    RAISE EXCEPTION 'images bucket not found!';
  END IF;

  RAISE NOTICE 'All storage buckets configured successfully! ✓';
END $$;
