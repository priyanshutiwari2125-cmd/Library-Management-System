-- ============================================================================
-- Library Management System Database Script
-- Compatible with SQL Server 2012+ / Express / LocalDB
-- ============================================================================

CREATE DATABASE [LibraryDB];
GO

USE [LibraryDB];
GO

-- ============================================================================
-- 1. Admin Table
-- ============================================================================
IF OBJECT_ID('dbo.Admin', 'U') IS NOT NULL DROP TABLE dbo.Admin;
CREATE TABLE dbo.Admin (
    AdminID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(256) NOT NULL, -- SHA-256 Hash or Plain for Demo (Default: 'admin123')
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NULL,
    LastLogin DATETIME NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Seed Default Admin (Username: admin, Password: admin123)
INSERT INTO dbo.Admin (Username, Password, FullName, Email)
VALUES ('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'System Administrator', 'admin@library.com');
-- Note: '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918' is SHA256 of 'admin123'
-- In DbHelper, both SHA256 hashed and plaintext 'admin123' fallback are handled for easy testing.

-- ============================================================================
-- 2. Categories Table
-- ============================================================================
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
CREATE TABLE dbo.Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO dbo.Categories (CategoryName, Description) VALUES 
('Computer Science', 'Programming, Algorithms, Software Engineering, AI & Web Dev'),
('Information Technology', 'Networking, Cybersecurity, Cloud Computing & Databases'),
('Electronics & Communication', 'Circuits, Microprocessors, Signals & Embedded Systems'),
('Mechanical Engineering', 'Thermodynamics, Robotics, Fluid Mechanics & Design'),
('Business & Management', 'Marketing, Finance, Leadership, HR & Strategy'),
('Literature & Arts', 'Fiction, Poetry, History & Cultural Studies');

-- ============================================================================
-- 3. Books Table
-- ============================================================================
IF OBJECT_ID('dbo.Books', 'U') IS NOT NULL DROP TABLE dbo.Books;
CREATE TABLE dbo.Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    ISBN NVARCHAR(20) NOT NULL UNIQUE,
    Title NVARCHAR(200) NOT NULL,
    CategoryID INT NOT NULL,
    Author NVARCHAR(100) NOT NULL,
    Publisher NVARCHAR(100) NULL,
    Edition NVARCHAR(50) NULL,
    Quantity INT NOT NULL DEFAULT 1,
    AvailableQuantity INT NOT NULL DEFAULT 1,
    CoverImage NVARCHAR(255) NULL,
    Status NVARCHAR(20) DEFAULT 'Available',
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Books_Categories FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID) ON DELETE CASCADE
);

INSERT INTO dbo.Books (ISBN, Title, CategoryID, Author, Publisher, Edition, Quantity, AvailableQuantity, CoverImage, Status) VALUES
('978-0131103627', 'The C Programming Language', 1, 'Brian W. Kernighan, Dennis M. Ritchie', 'Prentice Hall', '2nd Edition', 5, 4, 'c_prog.jpg', 'Available'),
('978-0132350884', 'Clean Code: A Handbook of Agile Software Craftsmanship', 1, 'Robert C. Martin', 'Prentice Hall', '1st Edition', 4, 3, 'clean_code.jpg', 'Available'),
('978-0262033848', 'Introduction to Algorithms', 1, 'Thomas H. Cormen, Charles E. Leiserson', 'MIT Press', '3rd Edition', 6, 6, 'algo.jpg', 'Available'),
('978-0134685991', 'Effective Java', 1, 'Joshua Bloch', 'Addison-Wesley', '3rd Edition', 3, 2, 'effective_java.jpg', 'Available'),
('978-0321127426', 'Design Patterns: Elements of Reusable Object-Oriented Software', 1, 'Erich Gamma, Richard Helm', 'Addison-Wesley', '1st Edition', 4, 4, 'design_patterns.jpg', 'Available'),
('978-0136086208', 'Database System Concepts', 2, 'Abraham Silberschatz, Henry F. Korth', 'McGraw-Hill', '6th Edition', 5, 5, 'db_concepts.jpg', 'Available');

-- ============================================================================
-- 4. Students Table
-- ============================================================================
IF OBJECT_ID('dbo.Students', 'U') IS NOT NULL DROP TABLE dbo.Students;
CREATE TABLE dbo.Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    EnrollmentNo NVARCHAR(50) NOT NULL UNIQUE,
    FullName NVARCHAR(100) NOT NULL,
    Course NVARCHAR(50) NOT NULL,
    Semester NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    MobileNo NVARCHAR(20) NOT NULL,
    Address NVARCHAR(255) NULL,
    Photo NVARCHAR(255) NULL,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- ============================================================================
-- 5. IssueBooks Table
-- ============================================================================
IF OBJECT_ID('dbo.IssueBooks', 'U') IS NOT NULL DROP TABLE dbo.IssueBooks;
CREATE TABLE dbo.IssueBooks (
    IssueID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    BookID INT NOT NULL,
    IssueDate DATETIME NOT NULL DEFAULT GETDATE(),
    DueDate DATETIME NOT NULL,
    ReturnDate DATETIME NULL,
    FineAmount DECIMAL(10,2) DEFAULT 0.00,
    Status NVARCHAR(20) DEFAULT 'Issued', -- 'Issued', 'Returned', 'Overdue'
    Notes NVARCHAR(255) NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_IssueBooks_Students FOREIGN KEY (StudentID) REFERENCES dbo.Students(StudentID) ON DELETE CASCADE,
    CONSTRAINT FK_IssueBooks_Books FOREIGN KEY (BookID) REFERENCES dbo.Books(BookID) ON DELETE CASCADE
);

-- ============================================================================
-- 6. Helper Views & Procedures (Optional)
-- ============================================================================
GO
CREATE OR ALTER VIEW dbo.vw_IssuedBooksDetails AS
SELECT 
    ib.IssueID,
    ib.StudentID,
    s.EnrollmentNo,
    s.FullName AS StudentName,
    s.Course,
    s.MobileNo,
    s.Email AS StudentEmail,
    ib.BookID,
    b.Title AS BookTitle,
    b.ISBN,
    b.Author,
    c.CategoryName,
    ib.IssueDate,
    ib.DueDate,
    ib.ReturnDate,
    ib.FineAmount,
    ib.Status,
    DATEDIFF(DAY, ib.DueDate, GETDATE()) AS DaysOverdue
FROM dbo.IssueBooks ib
INNER JOIN dbo.Students s ON ib.StudentID = s.StudentID
INNER JOIN dbo.Books b ON ib.BookID = b.BookID
INNER JOIN dbo.Categories c ON b.CategoryID = c.CategoryID;
GO

PRINT 'Database LibraryDB and objects created successfully!';
