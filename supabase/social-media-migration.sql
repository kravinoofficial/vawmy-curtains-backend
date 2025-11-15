-- Create social_media table
CREATE TABLE IF NOT EXISTS social_media (
  id SERIAL PRIMARY KEY,
  platform TEXT NOT NULL,
  url TEXT NOT NULL,
  icon_name TEXT NOT NULL,
  is_visible BOOLEAN DEFAULT true,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE social_media ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Social media links are viewable by everyone"
  ON social_media FOR SELECT
  USING (true);

-- Create policy for authenticated insert
CREATE POLICY "Authenticated users can insert social media"
  ON social_media FOR INSERT
  WITH CHECK (true);

-- Create policy for authenticated update
CREATE POLICY "Authenticated users can update social media"
  ON social_media FOR UPDATE
  USING (true);

-- Create policy for authenticated delete
CREATE POLICY "Authenticated users can delete social media"
  ON social_media FOR DELETE
  USING (true);

-- Insert default social media links
INSERT INTO social_media (platform, url, icon_name, is_visible, display_order) VALUES
('Facebook', 'https://facebook.com/vawmycurtains', 'facebook', true, 1),
('Instagram', 'https://instagram.com/vawmycurtains', 'instagram', true, 2),
('Pinterest', 'https://pinterest.com/vawmycurtains', 'pinterest', true, 3);
