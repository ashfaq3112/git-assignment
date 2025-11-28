-- 1. Enable pgcrypto for UUID generation (if using Postgres < v13)
-- In v13+, gen_random_uuid() is built-in, but this extension ensures compatibility.
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. Create the shoutouts table
CREATE TABLE shoutouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_nickname TEXT, -- Nullable (Optional)
    recipient_name TEXT NOT NULL,
    message_content TEXT NOT NULL,
    category TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,

    -- Enforce the category restrictions at the database level
    CONSTRAINT check_category_validity CHECK (category IN ('Thank You', 'Confession', 'Meme'))
);

-- 3. Create an Index for performance
-- Applications usually display shoutouts sorted by newest first.
-- This index speeds up that specific query.
CREATE INDEX idx_shoutouts_created_at ON shoutouts (created_at DESC);

-- 1. Enable RLS on the table
ALTER TABLE shoutouts ENABLE ROW LEVEL SECURITY;

-- 2. Allow Public Read Access (SELECT)
-- The expression "true" means all rows are visible to everyone.
CREATE POLICY "Enable public read access" 
ON shoutouts
FOR SELECT 
TO public 
USING (true);

-- 3. Allow Public Write Access (INSERT)
-- The expression "true" means anyone can insert rows without restriction.
CREATE POLICY "Enable public insert access" 
ON shoutouts
FOR INSERT 
TO public 
WITH CHECK (true);
