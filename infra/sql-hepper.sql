-- ###### Database và Schema Management ######
-- Liệt kê databases
\l

-- Kết nối database
\c database_name

-- Tạo database
CREATE DATABASE myapp_db;

-- Xóa database
DROP DATABASE database_name;

-- Xem current database
SELECT current_database();

-- Liệt kê schemas
\dn

-- ###### Table Operations ######
-- Liệt kê tables
\dt

-- Xem cấu trúc table
\d table_name

-- Chi tiết table với constraints
\d+ table_name

-- Tạo table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Thêm column
ALTER TABLE users ADD COLUMN age INTEGER;

-- Xóa column
ALTER TABLE users DROP COLUMN age;

-- Rename table
ALTER TABLE old_name RENAME TO new_name;


-- ###### Data Operations ######
-- Insert data
INSERT INTO users (name, email) VALUES ('John', 'john@example.com');

-- Update data
UPDATE users SET name = 'Jane' WHERE id = 1;

-- Delete data
DELETE FROM users WHERE id = 1;

-- Select với filter
SELECT * FROM users WHERE name LIKE 'J%';

-- Count records
SELECT COUNT(*) FROM users;

-- Limit results
SELECT * FROM users LIMIT 10 OFFSET 20;