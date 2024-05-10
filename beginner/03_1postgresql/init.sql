-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS taf;

-- Connect to the database
\c taf;


CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE,
  user_type INTEGER NOT NULL DEFAULT 0,
  verification_code VARCHAR(50),
  verified BOOLEAN DEFAULT false,
  verification_code_created_at TIMESTAMP
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE wallets (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  balance DECIMAL(10, 2) DEFAULT 0.00,
  currency VARCHAR(3) NOT NULL DEFAULT 'GMD',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  sender_id INTEGER NOT NULL REFERENCES users(id),
  recipient_id INTEGER NOT NULL REFERENCES users(id),
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'GMD',
  status VARCHAR(20) NOT NULL,
  transaction_type VARCHAR(20) NOT NULL,
  transaction_number VARCHAR(255),
  transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	
);


CREATE TABLE agents (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  verification_code VARCHAR(50),
  verified BOOLEAN DEFAULT false,
  verification_code_created_at TIMESTAMP,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
);

CREATE TABLE cash_transactions (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  agent_id INTEGER NOT NULL REFERENCES agents(id),
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'GMD',
  transaction_type VARCHAR(20) NOT NULL,
  transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE merchants (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  business_name VARCHAR(255),
  merchant_email VARCHAR(255),
  business_type VARCHAR(100),
  business_phone_number VARCHAR(20),
  description TEXT,
  address TEXT,
  website VARCHAR(255),
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
);



CREATE TABLE merchants_payments (
  id SERIAL PRIMARY KEY,
  merchant_id INTEGER NOT NULL REFERENCES merchants(id),
  user_id INTEGER NOT NULL REFERENCES users(id),
  product_id INTEGER NOT NULL REFERENCES products_and_services(id),
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'GMD',
  status VARCHAR(50) NOT NULL DEFAULT 'pending',
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
);



CREATE TABLE telecom_operators (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE airtime_topups (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  operator_id INTEGER NOT NULL REFERENCES telecom_operators(id),
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'GMD',
  topup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE utility_providers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bill_payments (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  provider_id INTEGER NOT NULL REFERENCES utility_providers(id),
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'GMD',
  billing_start_date DATE NOT NULL,
  billing_end_date DATE NOT NULL,
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rewards (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  points INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rewards_redemptions (
  id SERIAL PRIMARY KEY,
  reward_id INTEGER NOT NULL REFERENCES rewards(id),
  redemption_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE products_and_services (
    id SERIAL PRIMARY KEY,
    merchant_id INTEGER NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
	title TEXT,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
	is_product BOOLEAN NOT NULL DEFAULT TRUE,
	is_discounted BOOLEAN NOT NULL DEFAULT FALSE,
    discounted_amount DECIMAL(10, 2),
    on_sale BOOLEAN NOT NULL DEFAULT FALSE,
    on_sale_amount DECIMAL(10, 2),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Drop the existing constraint on the id column
ALTER TABLE products_and_services DROP CONSTRAINT products_and_services_pkey;

-- Alter the id column to be an INTEGER type
ALTER TABLE products_and_services ALTER COLUMN id SET DATA TYPE INTEGER;

-- Drop the sequence if exists
DROP SEQUENCE IF EXISTS products_and_services_id_seq;

-- Create a new sequence for the id column
CREATE SEQUENCE products_and_services_id_seq START 1;

-- Set the default value for the id column to use the sequence
ALTER TABLE products_and_services ALTER COLUMN id SET DEFAULT nextval('products_and_services_id_seq');

-- Add a new primary key constraint on the id column
ALTER TABLE products_and_services ADD PRIMARY KEY (id);




-- QR Codes table
CREATE TABLE qr_codes (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products_and_services(id),
    data TEXT NOT NULL
);



CREATE TABLE unverified_users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) UNIQUE,
  password_hash VARCHAR(255),
  phone_number VARCHAR(20) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE,
  verification_code VARCHAR(50),
  phone_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);