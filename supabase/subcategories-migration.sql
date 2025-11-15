-- ============================================
-- Subcategories Feature Migration
-- ============================================

-- Add video_url column to collections table
ALTER TABLE collections 
ADD COLUMN IF NOT EXISTS video_url TEXT;

-- Remove old images array (we'll use subcategories now)
-- Keep it for backward compatibility but it won't be used

-- Create subcategories table
DROP TABLE IF EXISTS subcategories CASCADE;

CREATE TABLE subcategories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  collection_id UUID NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  images TEXT[] DEFAULT ARRAY[]::TEXT[],
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT max_5_images CHECK (array_length(images, 1) <= 5)
);

-- Add indexes
CREATE INDEX idx_subcategories_collection_id ON subcategories(collection_id);
CREATE INDEX idx_subcategories_display_order ON subcategories(display_order ASC);

-- Enable Row Level Security
ALTER TABLE subcategories ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can read subcategories" ON subcategories;
DROP POLICY IF EXISTS "Allow all operations on subcategories" ON subcategories;

-- Public read access
CREATE POLICY "Public can read subcategories" 
ON subcategories
FOR SELECT 
USING (true);

-- Allow all write operations (backend handles auth)
CREATE POLICY "Allow all operations on subcategories" 
ON subcategories
FOR ALL 
USING (true)
WITH CHECK (true);

-- Add trigger for updated_at
DROP TRIGGER IF EXISTS update_subcategories_updated_at ON subcategories;
CREATE TRIGGER update_subcategories_updated_at
  BEFORE UPDATE ON subcategories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Verification
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'subcategories') THEN
    RAISE EXCEPTION 'subcategories table was not created';
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_name = 'collections' 
    AND column_name = 'video_url'
  ) THEN
    RAISE EXCEPTION 'video_url column was not added to collections';
  END IF;
  
  RAISE NOTICE 'Subcategories feature added successfully!';
END $$;
