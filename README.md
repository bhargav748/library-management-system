# library-management-system

## Project Overview
This **Library Management System** project is built using **SQLite** to manage books, users, and borrowing records in a library. It supports operations such as book borrowing, returning, and keeping track of availability using triggers. Views are used for easy access to information like available books and borrowed books.

## Features
- **Book Management**: Add, view, and update book information, including availability.
- **User Management**: Add users (Students or Faculty) and track their borrowing history.
- **Borrowing and Returning Books**: Keep track of borrowed books and update the system when they are returned.
- **Triggers**: Automatically update book availability after borrowing or returning.
- **Views**: Predefined queries for commonly accessed information such as available books and borrowed books.
- **Reports**: Generate reports on the most borrowed books, users with the most borrowings, etc.

## Project Structure
The project consists of the following core components:

1. **Tables**:
   - `Books`: Stores information about books (title, author, genre, availability).
   - `Users`: Stores information about users (students or faculty).
   - `Borrowed_Books`: Tracks borrowing history with book, user, borrow date, and return date.

2. **Triggers**:
   - `after_book_borrowed`: Automatically marks a book as unavailable after it’s borrowed.
   - `after_book_returned`: Automatically marks a book as available after it’s returned.

3. **Views**:
   - `Available_Books`: A view to see all available books in the library.
   - `User_Borrowed_Books`: A view to check which books are currently borrowed and by which users.

## Prerequisites
- SQLite 3 (or any SQLite-compatible environment)
  
Ensure SQLite is installed on your machine. You can download it from [SQLite Downloads](https://www.sqlite.org/download.html).

## Setup Instructions

1. **Clone the Repository (Optional)**:
   ```bash
   git clone https://github.com/yourusername/library-management-system
   cd library-management-system
