-- Check if the table exists
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'users') THEN
        -- Create the users table if it doesn't exist
        CREATE TABLE postgres.users (
            id SERIAL PRIMARY KEY,
            username VARCHAR(100) NOT NULL,
            email VARCHAR(100) NOT NULL,
            password VARCHAR(100) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );

        -- Insert sample data
        INSERT INTO postgres.users (username, email, password) VALUES 
            ('john_doe', 'john@example.com', 'password123'),
            ('jane_smith', 'jane@example.com', 'pass456');
    END IF;
END $$;
