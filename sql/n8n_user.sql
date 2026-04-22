
-- Grant connection to the database
GRANT CONNECT ON DATABASE nogales TO n8n_user;

-- Grant usage on schema
GRANT USAGE ON SCHEMA n8n TO n8n_user;

-- Grant all privileges on all existing tables, views, sequences and functions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA n8n TO n8n_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA n8n TO n8n_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA n8n TO n8n_user;

-- Grant privileges on future objects (default privileges)
ALTER DEFAULT PRIVILEGES IN SCHEMA n8n
    GRANT ALL PRIVILEGES ON TABLES TO n8n_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA n8n
    GRANT ALL PRIVILEGES ON SEQUENCES TO n8n_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA n8n
    GRANT ALL PRIVILEGES ON FUNCTIONS TO n8n_user;

-- Optional: make n8n_user the owner of the schema
-- ALTER SCHEMA n8n OWNER TO n8n_user;