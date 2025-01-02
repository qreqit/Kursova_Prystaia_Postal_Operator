-- Таблиця ролей співробітників
INSERT INTO EmployeeRoles (RoleName, Description)
VALUES
    (N'Кур''єр', N'Відповідає за доставку посилок'),
(N'Менеджер складу', N'Контролює стан складу та запаси'),
(N'Оператор', N'Працює з клієнтами та обробляє замовлення');

-- Таблиця локацій
INSERT INTO Locations (Address, City, PostalCode)
VALUES
(N'вул. Хрещатик, 22', N'Київ', N'01001'),
(N'вул. Сумська, 15', N'Харків', N'61000'),
(N'вул. Грушевського, 3', N'Львів', N'79000');

-- Таблиця регіонів
INSERT INTO ServiceRegions (RegionName)
VALUES
(N'Київська область'),
(N'Харківська область'),
(N'Львівська область');

-- Таблиця методів доставки
INSERT INTO ShippingMethods (MethodName, EstimatedDays, Cost)
VALUES
(N'Стандартна доставка', 5, 50.00),
(N'Експрес-доставка', 2, 100.00),
(N'Самовивіз', 0, 0.00);

-- Таблиця статусів
INSERT INTO Statuses (StatusName)
VALUES
(N'Очікується'),
(N'В дорозі'),
(N'Доставлено'),
(N'Отримано'),
(N'Скасовано');

    -- Таблиця користувачів
INSERT INTO Users (Username, Password, Email)
VALUES
(N'ivan_k', N'729821655484092431', N'ivan.k@example.com'),
(N'anna_s', N'-603558938241517705', N'anna.s@example.com'),
(N'petro_m', N'7364277615221867186', N'petro.m@example.com');

-- Таблиця адрес
INSERT INTO Addresses (UserId, Address, City, PostalCode, Country)
VALUES
(1, N'вул. Велика Житомирська, 10', N'Київ', N'01025', N'Україна'),
(2, N'вул. Полтавський Шлях, 45', N'Харків', N'61052', N'Україна'),
(3, N'вул. Шевченка, 12', N'Львів', N'79019', N'Україна');

-- Таблиця співробітників
INSERT INTO Employees (UserId, RoleId, HireDate, IsActive)
VALUES
(1, 1, '2023-01-15', 1),
(2, 2, '2022-11-01', 1),
(3, 3, '2024-02-20', 1);

-- Таблиця складів
INSERT INTO Warehouses (Address, Capacity, CurrentLoad, RegionId)
VALUES
    (N'вул. Промислова, 5', 1000, 250, 1),
    (N'вул. Металістів, 33', 2000, 1200, 2),
    (N'вул. Шосейна, 8', 1500, 300, 3);

-- Таблиця посилок
INSERT INTO Packages (SenderId, ReceiverId, CurrentStatusId, ShippingMethodId, WarehouseId, CreatedAt)
VALUES
    (1, 2, 2, 1, 1, GETDATE()),
    (2, 3, 3, 2, 2, GETDATE()),
    (3, 1, 1, 3, 3, GETDATE());

-- Таблиця інцидентів
INSERT INTO IncidentReports (UserId, PackageId, ReportType, Description)
VALUES
    (2, 1, N'Пошкодження', N'Пакунок пошкоджений під час транспортування'),
    (3, 2, N'Втрата', N'Посилка втрачена на складі'),
    (1, 3, N'Інше', N'Затримка доставки без пояснень');

-- Таблиця страхування посилок
INSERT INTO PackageInsurance (PackageId, InsuranceValue, PremiumAmount, CoverageDetails)
VALUES
    (1, 1000.00, 50.00, N'Покриває пошкодження та втрату'),
    (2, 2000.00, 100.00, N'Покриває втрату'),
    (3, 500.00, 25.00, N'Тільки пошкодження');

-- Таблиця локацій посилок
INSERT INTO PackageLocations (PackageId, LocationId, StatusId, Timestamp)
VALUES
    (1, 1, 2, GETDATE()),
    (2, 2, 3, GETDATE()),
    (3, 3, 1, GETDATE());

-- Таблиця платежів
INSERT INTO Payments (PackageId, Amount, PaymentDate, PaymentMethod)
VALUES
    (1, 150.00, GETDATE(), N'Кредитна картка'),
    (2, 250.00, GETDATE(), N'Готівка'),
    (3, 50.00, GETDATE(), N'Банківський переказ');

-- Таблиця відгуків
INSERT INTO Reviews (UserId, PackageId, Rating, Comment)
VALUES
    (1, 2, 5, N'Дуже швидка доставка, дякую!'),
    (2, 3, 4, N'Все добре, але була невелика затримка.'),
    (3, 1, 3, N'Посилка трохи пошкоджена, але прийнятно.');

-- Таблиця сповіщень
INSERT INTO Notifications (UserId, Message, IsRead, CreatedAt)
VALUES
    (1, N'Вашу посилку успішно доставлено!', 0, GETDATE()),
    (2, N'Нова інформація щодо вашої посилки.', 0, GETDATE()),
    (3, N'Посилка знаходиться у складі.', 1, GETDATE());