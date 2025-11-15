-- Create blog_posts table
CREATE TABLE IF NOT EXISTS blog_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  excerpt TEXT NOT NULL,
  content TEXT NOT NULL,
  cover_image TEXT NOT NULL,
  author TEXT NOT NULL DEFAULT 'Vawmy Team',
  published_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Blog posts are viewable by everyone"
  ON blog_posts FOR SELECT
  USING (true);

-- Create policy for authenticated insert
CREATE POLICY "Authenticated users can insert blog posts"
  ON blog_posts FOR INSERT
  WITH CHECK (true);

-- Create policy for authenticated update
CREATE POLICY "Authenticated users can update blog posts"
  ON blog_posts FOR UPDATE
  USING (true);

-- Create policy for authenticated delete
CREATE POLICY "Authenticated users can delete blog posts"
  ON blog_posts FOR DELETE
  USING (true);

-- Create index on slug for faster lookups
CREATE INDEX IF NOT EXISTS idx_blog_posts_slug ON blog_posts(slug);

-- Create index on published_date for sorting
CREATE INDEX IF NOT EXISTS idx_blog_posts_published_date ON blog_posts(published_date DESC);

-- Insert sample blog posts
INSERT INTO blog_posts (title, slug, excerpt, content, cover_image, author, published_date) VALUES
(
  'Transform Your Living Space with the Perfect Curtains',
  'transform-living-space-perfect-curtains',
  'Discover how the right curtains can completely change the ambiance of your home. Learn about fabric choices, colors, and styles.',
  '<p>Curtains are more than just window coverings—they''re a crucial element of interior design that can transform any room. Whether you''re looking to create a cozy atmosphere or add a touch of elegance, the right curtains make all the difference.</p><h2>Choosing the Right Fabric</h2><p>The fabric you choose impacts both aesthetics and functionality. Heavy fabrics like velvet provide excellent insulation and light blocking, while lighter materials like linen create an airy, relaxed feel.</p><h2>Color Psychology</h2><p>Colors affect mood and perception. Warm tones create intimacy, while cool colors make spaces feel larger and more serene.</p>',
  'https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg?auto=compress&cs=tinysrgb&w=800',
  'Vawmy Design Team',
  NOW() - INTERVAL '7 days'
),
(
  '5 Latest Curtain Trends for 2025',
  '5-latest-curtain-trends-2025',
  'Stay ahead of the curve with these emerging curtain trends that are defining interior design in 2025.',
  '<p>As we move through 2025, several exciting curtain trends are emerging that blend functionality with stunning aesthetics.</p><h2>1. Sustainable Fabrics</h2><p>Eco-friendly materials are taking center stage, with organic cotton and recycled polyester becoming increasingly popular.</p><h2>2. Bold Patterns</h2><p>Geometric patterns and botanical prints are making a strong comeback, adding personality to any space.</p><h2>3. Smart Curtains</h2><p>Motorized curtains with app control are becoming more accessible and affordable.</p>',
  'https://images.pexels.com/photos/667838/pexels-photo-667838.jpeg?auto=compress&cs=tinysrgb&w=800',
  'Vawmy Design Team',
  NOW() - INTERVAL '3 days'
),
(
  'How to Measure Your Windows for Custom Curtains',
  'measure-windows-custom-curtains',
  'A comprehensive guide to measuring your windows accurately for the perfect curtain fit.',
  '<p>Getting the right measurements is crucial for custom curtains. Follow our step-by-step guide to ensure a perfect fit.</p><h2>Tools You''ll Need</h2><p>A metal measuring tape, notepad, and pencil are essential. Avoid cloth measuring tapes as they can stretch.</p><h2>Width Measurements</h2><p>Measure the width of your window frame, then add 8-12 inches on each side for proper coverage and fullness.</p><h2>Length Measurements</h2><p>Decide where you want your curtains to end—at the sill, below the sill, or floor length—and measure accordingly.</p>',
  'https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?auto=compress&cs=tinysrgb&w=800',
  'Vawmy Team',
  NOW() - INTERVAL '1 day'
);
