USE Order_cash
GO

DELETE FROM Transactions
DELETE FROM Orders
DELETE FROM Accounts
DELETE FROM Documents
DELETE FROM Employees
DELETE FROM Branches
DELETE FROM Clients
GO

-- Сброс счетчиков identity
DBCC CHECKIDENT ('Clients', RESEED, 0)
DBCC CHECKIDENT ('Branches', RESEED, 0)
DBCC CHECKIDENT ('Employees', RESEED, 0)
DBCC CHECKIDENT ('Documents', RESEED, 0)
DBCC CHECKIDENT ('Accounts', RESEED, 0)
DBCC CHECKIDENT ('Orders', RESEED, 0)
DBCC CHECKIDENT ('Transactions', RESEED, 0)
GO

INSERT INTO Clients (name, surname, patronymic, mail, phone, date_of_birth, sign_up_date, status) VALUES
('Иван', 'Иванов', 'Иванович', 'ivanov@mail.ru', '+79011234567', '1985-03-15', '2023-01-10', 'active'),
('Петр', 'Петров', 'Петрович', 'petrov@yandex.ru', '+79022345678', '1990-07-22', '2023-02-15', 'active'),
('Сергей', 'Сидоров', 'Алексеевич', 'sidorov@gmail.com', '+79033456789', '1978-11-05', '2023-01-20', 'active'),
('Анна', 'Смирнова', 'Дмитриевна', 'smirnova@bk.ru', '+79044567890', '1995-09-18', '2023-03-05', 'active'),
('Елена', 'Козлова', 'Андреевна', 'kozlova@list.ru', '+79055678901', '1982-12-30', '2023-02-28', 'blocked')
GO

INSERT INTO Branches (address, city, phone, email) VALUES
('ул. Ленина, 10', 'Москва', '+74951234567', 'msk@bank.ru'),
('пр. Невский, 25', 'Санкт-Петербург', '+78121234567', 'spb@bank.ru'),
('ул. Красная, 5', 'Казань', '+78431234567', 'kzn@bank.ru')
GO

INSERT INTO Employees (branch_id, name, surname, patronymic, mail, phone, role) VALUES
(1, 'Алексей', 'Соколов', 'Викторович', 'sokolov@bank.ru', '+79061234567', 'manager'),
(1, 'Дмитрий', 'Морозов', 'Сергеевич', 'morozov@bank.ru', '+79071234567', 'consultant'),
(1, 'Ольга', 'Волкова', 'Игоревна', 'volkova@bank.ru', '+79081234567', 'cashier'),
(2, 'Максим', 'Лебедев', 'Андреевич', 'lebedev@bank.ru', '+79091234567', 'manager'),
(2, 'Татьяна', 'Соловьева', 'Павловна', 'soloveva@bank.ru', '+79101234567', 'consultant'),
(3, 'Артем', 'Кузнецов', 'Владимирович', 'kuznetsov@bank.ru', '+79111234567', 'manager'),
(3, 'Наталья', 'Васильева', 'Михайловна', 'vasileva@bank.ru', '+79121234567', 'consultant')
GO

INSERT INTO Documents (client_id, doc_type, number, series, issue_date, issued_by, expire_date, is_main, verification_status, scan_url) VALUES
(1, 'passport', '4512', '123456', '2010-05-20', 'ОВД Тверской район', '2030-05-20', 1, 'verified', '/scans/ivanov_passport.pdf'),
(1, 'driver_license', '7712', '654321', '2018-07-15', 'ГИБДД Москва', '2028-07-15', 0, 'verified', '/scans/ivanov_license.pdf'),
(2, 'passport', '4513', '234567', '2012-09-10', 'ОВД Центральный', '2032-09-10', 1, 'verified', '/scans/petrov_passport.pdf'),
(3, 'passport', '4514', '345678', '2005-11-30', 'ОВД Приволжский', '2025-11-30', 1, 'verified', '/scans/sidorov_passport.pdf'),
(4, 'passport', '4515', '456789', '2015-03-25', 'ОВД Московский', '2035-03-25', 1, 'pending', '/scans/smirnova_passport.pdf'),
(5, 'passport', '4516', '567890', '2008-12-05', 'ОВД Кировский', '2028-12-05', 1, 'verified', '/scans/kozlova_passport.pdf')
GO

INSERT INTO Accounts (client_id, account_number, currency, status, product_id, opened_at, balance, closed_at) VALUES
(1, '40817810000000000001', 'RUB', 'active', 1, '20230125', 150000.50, NULL),
(1, '40817840000000000001', 'USD', 'active', 2, '20230125', 5000.00, NULL),
(2, '40817810000000000002', 'RUB', 'active', 1, '20230125', 25000.00, NULL),
(2, '40817810000000000003', 'RUB', 'active', 3, '20230125', 100000.00, NULL),
(3, '40817810000000000004', 'RUB', 'active', 1, '20230125', 500000.00, NULL),
(4, '40817810000000000005', 'RUB', 'active', 1, '20230125', 75000.00, NULL),
(5, '40817810000000000006', 'RUB', 'closed', 1, '20230125', 0.00, '20231020')
GO

INSERT INTO Orders (branch_id, client_id, account_id, order_number, status, created_at, closed_at, assigned_employee_id, planned_date, actual_date, last_change, amount) VALUES
(1, 1, 1, 1001, 'completed', '20230110 10:30:00', '20230112 14:25:00', 2, '20230111', '20230112', '20230112 14:25:00', 5000.00),
(1, 3, 5, 1002, 'completed', '20230115 11:45:00', '20230116 09:30:00', 3, '20230116', '20230116', '20230116 09:30:00', 15000.00),
(2, 2, 2, 1003, 'completed', '20230205 09:15:00', '20230207 16:20:00', 5, '20230206', '20230207', '20230207 16:20:00', 8500.00),
(2, 4, 6, 1004, 'completed', '20230218 14:30:00', '20230220 11:10:00', 5, '20230219', '20230220', '20230220 11:10:00', 3200.00),
(1, 1, 1, 1005, 'completed', '20230222 12:00:00', '20230224 10:45:00', 2, '20230223', '20230224', '20230224 10:45:00', 12000.00),
(3, 3, 5, 1006, 'completed', '20230302 10:00:00', '20230303 15:30:00', 7, '20230303', '20230303', '20230303 15:30:00', 7500.00),
(3, 2, 3, 1007, 'completed', '20230310 11:30:00', '20230313 12:15:00', 7, '20230311', '20230313', '20230313 12:15:00', 22500.00),
(1, 4, 6, 1008, 'processing', '20230405 09:45:00', NULL, 3, '20230406', NULL, '20230405 09:45:00', 4300.00),
(2, 5, 7, 1009, 'cancelled', '20230412 16:20:00', '20230413 09:00:00', 4, '20230413', NULL, '20230413 09:00:00', 8000.00),
(1, 1, 1, 1010, 'created', '20230515 13:10:00', NULL, 2, '20230516', NULL, '20230515 13:10:00', 9500.00)
GO

INSERT INTO Transactions (account_id, type, created_at, amount, description) VALUES
(1, 'debit', '20230110', 5000.00, 'Оплата заказа'),
(5, 'debit', '20230110', 15000.00, 'Оплата заказа'),
(2, 'debit', '20230110', 8500.00, 'Оплата заказа'),
(6, 'debit', '20230110', 3200.00, 'Оплата заказа'),
(1, 'debit', '20230110', 12000.00, 'Оплата заказа'),
(5, 'debit', '20230110', 7500.00, 'Оплата заказа'),
(3, 'debit', '20230110', 22500.00, 'Оплата заказа'),
(1, 'credit', '20230110', 50000.00, 'Пополнение карты'),
(1, 'credit', '20230110', 30000.00, 'Зарплата'),
(2, 'credit', '20230110', 2000.00, 'Перевод от Иванова'),
(3, 'credit', '20230110', 15000.00, 'Пополнение наличными'),
(5, 'credit', '20230110', 100000.00, 'Перевод с другого счета')
GO

SELECT * FROM Clients 
SELECT * FROM Branches 
SELECT * FROM Employees 
SELECT * FROM Documents 
SELECT * FROM Accounts 
SELECT * FROM Orders 
SELECT * FROM Transactions