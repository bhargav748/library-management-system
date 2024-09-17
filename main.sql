-- Drop Tables if They Already Exist
DROP TABLE IF EXISTS Borrowed_Books;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Books;

-- Create Books Table
CREATE TABLE IF NOT EXISTS Books (
    book_id INTEGER PRIMARY KEY,  -- SQLite auto-increments INTEGER PRIMARY KEY
    title TEXT NOT NULL,
    author TEXT,
    genre TEXT,
    availability BOOLEAN DEFAULT 1
);

-- Create Users Table
CREATE TABLE IF NOT EXISTS Users (
    user_id INTEGER PRIMARY KEY,  -- SQLite auto-increments INTEGER PRIMARY KEY
    name TEXT NOT NULL,
    membership_date DATE NOT NULL,
    type TEXT CHECK(type IN ('Student', 'Faculty'))
);

-- Create Borrowed_Books Table
CREATE TABLE IF NOT EXISTS Borrowed_Books (
    borrow_id INTEGER PRIMARY KEY,  -- SQLite auto-increments INTEGER PRIMARY KEY
    book_id INTEGER,
    user_id INTEGER,
    borrow_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Insert Sample Data into Books Table
INSERT INTO Books (title, author, genre, availability) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 1),
('1984', 'George Orwell', 'Dystopian', 1),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', 1),
('Moby-Dick', 'Herman Melville', 'Adventure', 1);

-- Insert Sample Data into Users Table
INSERT INTO Users (name, membership_date, type) VALUES
('Alice Johnson', '2023-01-15', 'Student'),
('Bob Smith', '2023-02-10', 'Faculty'),
('Charlie Brown', '2023-03-20', 'Student');

-- Insert Sample Data into Borrowed_Books Table
INSERT INTO Borrowed_Books (book_id, user_id, borrow_date, return_date) VALUES
(1, 1, '2024-09-01', NULL), -- Alice borrows 'The Great Gatsby'
(3, 2, '2024-09-05', '2024-09-12'); -- Bob borrows 'To Kill a Mockingbird'

-- View All Available Books
SELECT * FROM Books WHERE availability = 1;

-- Borrow a Book (Mark as Borrowed)
UPDATE Books
SET availability = 0
WHERE book_id = 1;  -- Example: The Great Gatsby

-- Insert Borrowing Record
INSERT INTO Borrowed_Books (book_id, user_id, borrow_date)
VALUES (1, 1, DATE('now'));  -- Example: Alice borrows The Great Gatsby

-- Return a Book (Mark as Returned)
UPDATE Books
SET availability = 1
WHERE book_id = 1;  -- Example: The Great Gatsby

-- Update Borrowing Record with Return Date
UPDATE Borrowed_Books
SET return_date = DATE('now')
WHERE book_id = 1 AND user_id = 1 AND return_date IS NULL;

-- View All Borrowed Books
SELECT b.borrow_id, u.name AS user_name, bo.title AS book_title, b.borrow_date, b.return_date
FROM Borrowed_Books b
JOIN Users u ON b.user_id = u.user_id
JOIN Books bo ON b.book_id = bo.book_id
WHERE b.return_date IS NULL;

-- Borrowing History Report for a User
SELECT bo.title AS book_title, b.borrow_date, b.return_date
FROM Borrowed_Books b
JOIN Books bo ON b.book_id = bo.book_id
WHERE b.user_id = 1;  -- Example: Alice's history

-- List Books Borrowed but Not Returned
SELECT u.name AS user_name, bo.title AS book_title, b.borrow_date
FROM Borrowed_Books b
JOIN Users u ON b.user_id = u.user_id
JOIN Books bo ON b.book_id = bo.book_id
WHERE b.return_date IS NULL;

-- Create View for Available Books
CREATE VIEW IF NOT EXISTS Available_Books AS
SELECT book_id, title, author, genre
FROM Books
WHERE availability = 1;

-- Create View for User Borrowed Books
CREATE VIEW IF NOT EXISTS User_Borrowed_Books AS
SELECT u.name, bo.title, b.borrow_date, b.return_date
FROM Borrowed_Books b
JOIN Users u ON b.user_id = u.user_id
JOIN Books bo ON b.book_id = bo.book_id;

-- Trigger to Update Availability after Borrowing
CREATE TRIGGER IF NOT EXISTS after_book_borrowed
AFTER INSERT ON Borrowed_Books
FOR EACH ROW
BEGIN
  UPDATE Books
  SET availability = 0
  WHERE book_id = NEW.book_id;
END;

-- Trigger to Update Availability after Returning
CREATE TRIGGER IF NOT EXISTS after_book_returned
AFTER UPDATE ON Borrowed_Books
FOR EACH ROW
WHEN NEW.return_date IS NOT NULL  -- Only execute when a return_date is set
BEGIN
  UPDATE Books
  SET availability = 1
  WHERE book_id = NEW.book_id;
END;

-- Most Borrowed Books Query
SELECT bo.title, COUNT(b.borrow_id) AS borrow_count
FROM Borrowed_Books b
JOIN Books bo ON b.book_id = bo.book_id
GROUP BY bo.title
ORDER BY borrow_count DESC;

-- List Users Who Have Borrowed More Than 2 Books
SELECT u.name, COUNT(b.borrow_id) AS books_borrowed
FROM Borrowed_Books b
JOIN Users u ON b.user_id = u.user_id
GROUP BY u.name
HAVING books_borrowed > 2;
