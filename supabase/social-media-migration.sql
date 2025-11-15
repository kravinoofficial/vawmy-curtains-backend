-- ============================================
-- Social Media Table Migration
-- ============================================

-- Drop existing table if it exists
DROP TABLE IF EXISTS social_media CASCADE;

-- Create social_media table
CREATE TABLE social_media (
  id SERIAL PRIMARY KEY,
  platform TEXT NOT NULL,
  url TEXT NOT NULL,
  icon_name TEXT NOT NULL DEFAULT 'facebook',
  is_visible BOOLEAN DEFAULT true,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add index for faster queries
CREATE INDEX idx_social_media_display_order ON social_media(display_order ASC);
CREATE INDEX idx_social_media_visible ON social_media(is_visible);

-- Enable Row Level Security
ALTER TABLE social_media ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can read social media" ON social_media;
DROP POLICY IF EXISTS "Allow all operations on social media" ON social_media;

-- Public read access
CREATE POLICY "Public can read social media" 
ON social_media
FOR SELECT 
USING (true);

-- Allow all write operations (backend handles auth)
CREATE POLICY "Allow all operations on social media" 
ON social_media
FOR ALL 
USING (true)
WITH CHECK (true);

-- Add trigger for updated_at
DROP TRIGGER IF EXISTS update_social_media_updated_at ON social_media;
CREATE TRIGGER update_social_media_updated_at
  BEFORE UPDATE ON social_media
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert default social media links
INSERT INTO social_media (platform, url, icon_name, is_visible, display_order)
VALUES 
  ('Facebook', 'https://facebook.com/vawmycurtains', 'facebook', true, 1),
  ('Instagram', 'https://instagram.com/vawmycurtains', 'instagram', true, 2),
  ('Pinterest', 'https://pinterest.com/vawmycurtains', 'pinterest', true, 3)
ON CONFLICT DO NOTHING;

-- Verification
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'social_media') THEN
    RAISE EXCEPTION 'social_media table was not created';
  END IF;
  
  RAISE NOTICE 'Social media table created successfully!';
END $$;
