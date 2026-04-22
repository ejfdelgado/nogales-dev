
-- Grant connection to the database
GRANT CONNECT ON DATABASE nogales TO rag_user;

-- Grant usage on schema
GRANT USAGE ON SCHEMA rag TO rag_user;

-- Grant all privileges on all existing tables, views, sequences and functions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA rag TO rag_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA rag TO rag_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA rag TO rag_user;

-- Grant privileges on future objects (default privileges)
ALTER DEFAULT PRIVILEGES IN SCHEMA rag
    GRANT ALL PRIVILEGES ON TABLES TO rag_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA rag
    GRANT ALL PRIVILEGES ON SEQUENCES TO rag_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA rag
    GRANT ALL PRIVILEGES ON FUNCTIONS TO rag_user;

-- Optional: make rag_user the owner of the schema
-- ALTER SCHEMA rag OWNER TO rag_user;