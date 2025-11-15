-- Add display_order column to collections table
ALTER TABLE collections 
ADD COLUMN IF NOT EXISTS display_order INTEGER DEFAULT 0;

-- Create index for faster ordering queries
CREATE INDEX IF NOT EXISTS idx_collections_display_order ON collections(display_order ASC);

-- Update existing collections with default order (based on creation date)
UPDATE collections 
SET display_order = (
  SELECT ROW_NUMBER() OVER (ORDER BY created_at ASC) 
  FROM collections c2 
  WHERE c2.id = collections.id
)
WHERE display_order = 0;

-- Verification
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_name = 'collections' 
    AND column_name = 'display_order'
  ) THEN
    RAISE NOTICE 'display_order column added successfully!';
  ELSE
    RAISE EXCEPTION 'Failed to add display_order column';
  END IF;
END $$;
