# Supabase Database Setup Guide

This folder contains all SQL scripts needed to set up your Vawmy Curtains database.

## Files Overview

1. **migrations.sql** - Main database schema (REQUIRED)
2. **storage-policy.sql** - Storage bucket policies (REQUIRED)
3. **seed-data.sql** - Sample collections data (OPTIONAL)

## Setup Instructions

### Step 1: Run Migrations (REQUIRED)

1. Open your Supabase project dashboard
2. Go to **SQL Editor**
3. Click **New Query**
4. Copy and paste the entire contents of `migrations.sql`
5. Click **Run** or press `Ctrl+Enter`

**What this does:**
- Creates `collections` table
- Creates `contact_info` table with default data
- Sets up Row Level Security (RLS) policies
- Creates triggers for automatic `updated_at` timestamps
- Adds indexes for better performance

**Expected output:**
```
NOTICE: Database schema created successfully!
```

### Step 2: Create Storage Bucket (REQUIRED)

1. In Supabase dashboard, go to **Storage**
2. Click **New bucket**
3. Name it: `collection-images`
4. Make it **Public** (toggle the public option)
5. Click **Create bucket**

### Step 3: Run Storage Policies (REQUIRED)

1. Go back to **SQL Editor**
2. Click **New Query**
3. Copy and paste the entire contents of `storage-policy.sql`
4. Click **Run**

**What this does:**
- Allows public read access to images
- Allows uploads, updates, and deletes (backend validates auth)

**Expected output:**
```
NOTICE: Storage policies created successfully for collection-images bucket!
```

### Step 4: Add Sample Data (OPTIONAL)

If you want to start with sample collections:

1. Go to **SQL Editor**
2. Click **New Query**
3. Copy and paste the entire contents of `seed-data.sql`
4. Click **Run**

**What this does:**
- Adds 4 sample collections with images
- You can skip this and add collections via the admin portal instead

**Expected output:**
```
NOTICE: Seed data inserted successfully! Total collections: 4
```

## Verification

After running all scripts, verify your setup:

### Check Tables

```sql
-- Check collections table
SELECT * FROM collections;

-- Check contact_info table
SELECT * FROM contact_info;
```

### Check Storage Bucket

```sql
-- Check if bucket exists
SELECT * FROM storage.buckets WHERE id = 'collection-images';

-- Check storage policies
SELECT * FROM pg_policies WHERE tablename = 'objects';
```

### Check RLS Policies

```sql
-- Check collections policies
SELECT * FROM pg_policies WHERE tablename = 'collections';

-- Check contact_info policies
SELECT * FROM pg_policies WHERE tablename = 'contact_info';
```

## Troubleshooting

### Error: "relation already exists"

If you see this error, it means tables already exist. You have two options:

**Option 1: Drop and recreate (CAUTION: This deletes all data)**
```sql
DROP TABLE IF EXISTS collections CASCADE;
DROP TABLE IF EXISTS contact_info CASCADE;
-- Then run migrations.sql again
```

**Option 2: Skip migrations**
If tables exist and are correct, just skip to storage setup.

### Error: "policy already exists"

The scripts now handle this automatically with `DROP POLICY IF EXISTS`.

### Error: "bucket does not exist"

Make sure you created the `collection-images` bucket in Step 2 before running storage policies.

### Images won't upload

1. Verify bucket is **public**
2. Check storage policies are applied
3. Verify backend has correct Supabase credentials
4. Check browser console for errors

## Clean Reinstall

If you need to start fresh:

```sql
-- Drop everything
DROP TABLE IF EXISTS collections CASCADE;
DROP TABLE IF EXISTS contact_info CASCADE;
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- Delete storage bucket (do this in UI or via SQL)
-- Then follow setup instructions from Step 1
```

## Database Schema

### collections table
```
id              UUID (Primary Key, Auto-generated)
name            TEXT (Required)
description     TEXT (Required)
cover_image     TEXT (Required, URL)
images          TEXT[] (Array of URLs)
created_at      TIMESTAMP (Auto-generated)
updated_at      TIMESTAMP (Auto-updated)
```

### contact_info table
```
id              INTEGER (Always 1, Single row)
email           TEXT (Required)
phone           TEXT (Required)
address         TEXT (Required)
hours           TEXT (Required)
updated_at      TIMESTAMP (Auto-updated)
```

## Security Notes

- RLS is enabled on all tables
- Public can read all data
- Backend validates writes via Basic Auth
- Storage bucket is public for read, backend validates uploads
- No sensitive data should be stored in these tables
