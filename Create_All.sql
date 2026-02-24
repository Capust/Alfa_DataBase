USE master
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Order_cash')
BEGIN
    DROP DATABASE Order_cash
END
GO

CREATE DATABASE Order_cash
GO

USE Order_cash
GO

-- Clients
IF OBJECT_ID('Clients', 'U') IS NOT NULL DROP TABLE Clients
GO

CREATE TABLE Clients(
    client_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(60) NOT NULL,
    patronymic VARCHAR(60),
    mail VARCHAR(200) UNIQUE,
    phone CHAR(12) UNIQUE NOT NULL CHECK (phone LIKE '+7%'),
    date_of_birth DATE NOT NULL,
    sign_up_date DATE NOT NULL DEFAULT GETDATE(),
    status VARCHAR(10) NOT NULL CHECK (status IN ('active', 'blocked', 'inactive'))
)
GO

-- Documents
IF OBJECT_ID('Documents', 'U') IS NOT NULL DROP TABLE Documents
GO

CREATE TABLE Documents (
    doc_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    doc_type VARCHAR(32) NOT NULL,
    number VARCHAR(20) UNIQUE NOT NULL,
    series VARCHAR(10),
    issue_date DATE NOT NULL,
    issued_by VARCHAR(200) NOT NULL,
    expire_date DATE,  
    is_main BIT DEFAULT 0,
    verification_status VARCHAR(20) DEFAULT 'pending',
    scan_url VARCHAR(512) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
)
GO

ALTER TABLE Documents
ADD CONSTRAINT FK_Documents_Clients
FOREIGN KEY (client_id) REFERENCES Clients(client_id)
GO

-- Branches
IF OBJECT_ID('Branches', 'U') IS NOT NULL DROP TABLE Branches
GO

CREATE TABLE Branches (
    branch_id INT IDENTITY(1,1) PRIMARY KEY,
    address VARCHAR(200) UNIQUE NOT NULL,
    city VARCHAR(100),
    phone CHAR(12) UNIQUE NOT NULL CHECK (phone LIKE '+7%'),
    email VARCHAR(100)
)
GO

-- Employees
IF OBJECT_ID('Employees', 'U') IS NOT NULL DROP TABLE Employees
GO

CREATE TABLE Employees (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(60) NOT NULL,
    patronymic VARCHAR(60),
    mail VARCHAR(200) UNIQUE,
    phone CHAR(12) UNIQUE NOT NULL CHECK (phone LIKE '+7%'),
    role VARCHAR(60) NOT NULL
)
GO

ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Branches
FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
GO

-- Accounts
IF OBJECT_ID('Accounts', 'U') IS NOT NULL DROP TABLE Accounts
GO

CREATE TABLE Accounts (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    account_number VARCHAR(34) NOT NULL UNIQUE,
    currency CHAR(3) NOT NULL DEFAULT 'RUB' CHECK (currency IN ('RUB', 'USD', 'EUR', 'GBP', 'CHF', 'CNY')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'blocked', 'closed', 'frozen', 'pending')),
    product_id INT NOT NULL,
    opened_at DATETIME NOT NULL DEFAULT GETDATE(),
    balance DECIMAL(19,2) NOT NULL DEFAULT 0,
    closed_at DATETIME NULL,
    
    CONSTRAINT CHK_Account_Balance CHECK (
        (status = 'closed' AND balance = 0) OR (status != 'closed')
    ),
    CONSTRAINT CHK_Account_Dates CHECK (
        (closed_at IS NULL) OR (closed_at >= opened_at)
    )
)
GO

ALTER TABLE Accounts
ADD CONSTRAINT FK_Accounts_Clients
FOREIGN KEY (client_id) REFERENCES Clients(client_id)
GO

-- Orders
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders
GO

CREATE TABLE Orders(
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT,
    client_id INT,
    account_id INT,
    order_number INT NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'created'
        CHECK (status IN ('created', 'processing', 'completed', 'cancelled', 'pending')),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    closed_at DATETIME,
    assigned_employee_id INT,
    planned_date DATETIME,
    actual_date DATETIME,
    last_change DATETIME NOT NULL DEFAULT GETDATE(),
    amount DECIMAL(19,2) NOT NULL
)
GO

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Branches
FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
GO

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Clients
FOREIGN KEY (client_id) REFERENCES Clients(client_id)
GO

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Accounts
FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
GO

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Employees
FOREIGN KEY (assigned_employee_id) REFERENCES Employees(employee_id)
GO

-- Transactions
IF OBJECT_ID('Transactions', 'U') IS NOT NULL DROP TABLE Transactions
GO

CREATE TABLE Transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    account_id INT NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('credit', 'debit', 'transfer', 'payment', 'fee', 'refund')),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    amount DECIMAL(19,2) NOT NULL,
    description NVARCHAR(1000)
)
GO

ALTER TABLE Transactions
ADD CONSTRAINT FK_Transactions_Accounts
FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
GO
