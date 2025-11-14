-- ============================================
-- Vawmy Curtains Database Schema
-- ============================================

-- Drop existing tables if they exist (for clean reinstall)
DROP TABLE IF EXISTS collections CASCADE;
DROP TABLE IF EXISTS contact_info CASCADE;

-- ============================================
-- Create collections table
-- ============================================
CREATE TABLE collections (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  cover_image TEXT NOT NULL,
  images TEXT[] DEFAULT ARRAY[]::TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add index for faster queries
CREATE INDEX idx_collections_created_at ON collections(created_at DESC);

-- ============================================
-- Create contact_info table
-- ============================================
CREATE TABLE contact_info (
  id INTEGER PRIMARY KEY DEFAULT 1,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL,
  hours TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT single_row CHECK (id = 1)
);

-- Insert default contact info
INSERT INTO contact_info (id, email, phone, address, hours)
VALUES (
  1,
  'info@vawmycurtains.com',
  '+1 (555) 123-4567',
  '123 Main Street, City, State 12345',
  'Mon-Fri: 9AM-6PM, Sat: 10AM-4PM'
)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- Enable Row Level Security
-- ============================================
ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_info ENABLE ROW LEVEL SECURITY;

-- ============================================
-- RLS Policies for collections
-- ============================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can read collections" ON collections;
DROP POLICY IF EXISTS "Allow all operations on collections" ON collections;

-- Public read access
CREATE POLICY "Public can read collections" 
ON collections
FOR SELECT 
USING (true);

-- Allow all write operations (backend handles auth)
CREATE POLICY "Allow all operations on collections" 
ON collections
FOR ALL 
USING (true)
WITH CHECK (true);

-- ============================================
-- RLS Policies for contact_info
-- ============================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Public can read contact info" ON contact_info;
DROP POLICY IF EXISTS "Allow all operations on contact info" ON contact_info;

-- Public read access
CREATE POLICY "Public can read contact info" 
ON contact_info
FOR SELECT 
USING (true);

-- Allow all write operations (backend handles auth)
CREATE POLICY "Allow all operations on contact info" 
ON contact_info
FOR ALL 
USING (true)
WITH CHECK (true);

-- ============================================
-- Triggers for updated_at
-- ============================================

-- Drop existing function if it exists
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add triggers
DROP TRIGGER IF EXISTS update_collections_updated_at ON collections;
CREATE TRIGGER update_collections_updated_at
  BEFORE UPDATE ON collections
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_contact_info_updated_at ON contact_info;
CREATE TRIGGER update_contact_info_updated_at
  BEFORE UPDATE ON contact_info
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- Verification
-- ============================================

-- Verify tables were created
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'collections') THEN
    RAISE EXCEPTION 'collections table was not created';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'contact_info') THEN
    RAISE EXCEPTION 'contact_info table was not created';
  END IF;
  
  RAISE NOTICE 'Database schema created successfully!';
END $$;
