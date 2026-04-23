
-- Grant connection to the database
GRANT CONNECT ON DATABASE n8n TO n8n_user;

-- Grant usage on the public schema
GRANT USAGE ON SCHEMA public TO n8n_user;

-- Grant all privileges on all existing tables, sequences, and functions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO n8n_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO n8n_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO n8n_user;

-- Grant privileges on future tables, sequences, and functions automatically
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO n8n_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO n8n_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON FUNCTIONS TO n8n_user;
