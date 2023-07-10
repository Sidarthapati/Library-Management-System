-- Create Books table
CREATE TABLE Books (
  Book_ID INT NOT NULL PRIMARY KEY,
  Title VARCHAR(255) NOT NULL,
  Author VARCHAR(255) NOT NULL,
  Publisher_ID INT NOT NULL,
  ISBN VARCHAR(13) NOT NULL,
  Copies INT NOT NULL
);

-- Create Users table
CREATE TABLE Users (
  User_ID INT NOT NULL PRIMARY KEY,
  Username VARCHAR(255) NOT NULL,
  User_address VARCHAR(255) NOT NULL,
  Contact VARCHAR(15) NOT NULL,
  LibraryCardNumber VARCHAR(20) NOT NULL
);

-- Create CirculationRecords table
CREATE TABLE CirculationRecords (
  CirculationID INT NOT NULL PRIMARY KEY,
  Book_ID INT NOT NULL,
  User_ID INT NOT NULL,
  Checkout_Date DATE NOT NULL,
  Due_Date DATE NOT NULL,
  Return_Date DATE DEFAULT '1000-01-01',
  FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID),
  FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
  CHECK (Book_ID IS NOT NULL),
  CHECK (User_ID IS NOT NULL),
  CHECK (Checkout_Date IS NOT NULL),
  CHECK (Due_Date IS NOT NULL),
  CHECK (Return_Date IS NOT NULL)
);

-- Create Fines table
CREATE TABLE Fines (
  FineID INT NOT NULL PRIMARY KEY,
  User_ID INT NOT NULL,
  Book_ID INT NOT NULL,
  Fine_Amount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
  FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID),
  CHECK (User_ID IS NOT NULL),
  CHECK (Book_ID IS NOT NULL),
  CHECK (Fine_Amount >= 0)
);

-- Add check constraints for Books table
ALTER TABLE Books ADD CHECK (Title IS NOT NULL);
ALTER TABLE Books ADD CHECK (Author IS NOT NULL);

-- Add check constraints for Users table
ALTER TABLE Users ADD CHECK (Username IS NOT NULL);
ALTER TABLE Users ADD CHECK (User_address IS NOT NULL);

-- Populate Books table
INSERT INTO Books (Book_ID, Title, Author, Publisher_ID, ISBN, Copies) VALUES
  (1, 'To Kill a Mockingbird', 'Harper Lee', 1, '9780446310789', 5),
  (2, 'Pride and Prejudice', 'Jane Austen', 2, '9780141439518', 3),
  (3, 'The Great Gatsby', 'F. Scott Fitzgerald', 3, '9780743273565', 2),
  (4, '1984', 'George Orwell', 4, '9780451524935', 4),
  (5, 'Animal Farm', 'George Orwell', 4, '9780451526342', 1);

-- Populate Users table
INSERT INTO Users (User_ID, Username, User_address, Contact, LibraryCardNumber) 
VALUES
  (1, 'Alice', '123 Main St, Anytown USA', '5551234', '12345'),
  (2, 'Bob', '456 Oak Ave, Anytown USA', '5555678', '67890'),
  (3, 'Charlie', '789 Maple St, Anytown USA', '5559012', '34567'),
  (4, 'David', '246 Elm St, Anytown USA', '5553456', '89012'),
  (5, 'Eve', '135 Pine St, Anytown USA', '5556789', '45678');

-- Populate CirculationRecords table
INSERT INTO CirculationRecords (CirculationID, Book_ID, User_ID, Checkout_Date, Due_Date, Return_Date)
VALUES 
(1, 1, 1, '2022-05-15', '2022-05-25', '2022-05-25'),
(2, 2, 2, '2022-05-17', '2022-05-27','1001-01-01'),
(3, 3, 3, '2022-05-18', '2022-05-28', '2022-06-05'),
(4, 4, 4, '2022-05-20', '2022-05-30', '2022-05-30'),
(5, 5, 5, '2022-05-22', '2022-06-01', '2022-06-02');

INSERT INTO Fines (FineID, User_ID, Book_ID, Fine_Amount)
VALUES 
(1, 1, 1, 0.00),
(2, 2, 2, 0.00),
(3, 3, 3, 20.00),
(4, 4, 4, 0.00),
(5, 5, 5, 2.50);

-- all books currently in library
SELECT * FROM Books


-- all active users in library
SELECT * FROM Users


-- Total fines
SELECT SUM(Fine_Amount) AS TotalFines 
FROM Fines


-- Sample Query 1: all books currently checked out
SELECT Books.*
FROM Books
INNER JOIN CirculationRecords ON Books.Book_ID = CirculationRecords.Book_ID
WHERE CirculationRecords.Return_Date = '1001-01-01';


-- Sample Query 2: total fines by given user
SELECT SUM(Fines.Fine_Amount) AS TotalFines
FROM Fines
INNER JOIN CirculationRecords ON Fines.Book_ID = CirculationRecords.Book_ID
AND Fines.User_ID = CirculationRecords.User_ID
INNER JOIN Users ON CirculationRecords.User_ID = Users.User_ID
WHERE Users.User_ID = 1;