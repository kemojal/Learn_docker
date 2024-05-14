-- Create the users table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL
);

-- Create the habits table
CREATE TABLE habits (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  target_days INT NOT NULL,
  completed_days INT NOT NULL DEFAULT 0,
  user_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);


INSERT INTO users (name, email, password) VALUES
('John Doe', 'john@example.com', 'password123'),
('Jane Smith', 'jane@example.com', 'password456'),
('Alice Johnson', 'alice@example.com', 'password789');

INSERT INTO habits (name, target_days, completed_days, user_id) VALUES
('Exercise', 5, 3, 1),
('Meditation', 7, 7, 2),
('Reading', 7, 5, 3),
('Writing', 5, 2, 1),
('Coding', 7, 6, 3);

