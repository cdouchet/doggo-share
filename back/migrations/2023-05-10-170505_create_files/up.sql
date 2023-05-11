CREATE TABLE IF NOT EXISTS files (
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    net_url TEXT NOT NULL UNIQUE,
    local_url TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL
)