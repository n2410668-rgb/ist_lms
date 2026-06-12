-- =============================================
--   IST LMS - Library Management System
--   Database Setup
-- =============================================

CREATE DATABASE IF NOT EXISTS ist_lms;
USE ist_lms;

-- -----------------------------------------------
-- ADMINS TABLE
-- -----------------------------------------------
CREATE TABLE admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,  -- stores hashed password
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------
-- STUDENTS TABLE
-- -----------------------------------------------
CREATE TABLE students (
    student_id VARCHAR(50) PRIMARY KEY,   -- e.g. IST123
    full_name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,       -- stores hashed password
    department VARCHAR(100) DEFAULT 'CS',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------
-- BOOKS TABLE
-- -----------------------------------------------
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    category VARCHAR(100) DEFAULT 'General',
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------
-- BORROWINGS TABLE
-- -----------------------------------------------
CREATE TABLE borrowings (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(50) NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE DEFAULT NULL,
    status ENUM('issued', 'returned', 'overdue') DEFAULT 'issued',
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- -----------------------------------------------
-- SAMPLE DATA
-- -----------------------------------------------

-- Default admin (password: admin123)
INSERT INTO admins (name, email, password) VALUES
('Admin User', 'admin@ist.edu', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- Sample books
INSERT INTO books (title, author, category, total_copies, available_copies) VALUES
('Clean Code', 'Robert C. Martin', 'Tech', 3, 3),
('DBMS Fundamentals', 'Elmasri & Navathe', 'Tech', 2, 2),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 2, 2),
('Introduction to Python', 'Mark Lutz', 'Tech', 4, 4),
('Operating Systems', 'Silberschatz', 'Tech', 2, 2),
('Data Structures', 'Cormen', 'Tech', 3, 3);

-- Sample student (password: student123)
INSERT INTO students (student_id, full_name, password, department) VALUES
('IST101', 'Noor Fatima', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'CS');
