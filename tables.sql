-- Таблиця регіонів для складів
CREATE TABLE ServiceRegions (
                                RegionId INT IDENTITY(1,1) PRIMARY KEY,
                                RegionName NVARCHAR(100) NOT NULL
);

-- Таблиця користувачів
CREATE TABLE Users (
                       UserId INT IDENTITY(1,1) PRIMARY KEY,
                       Username NVARCHAR(50) NOT NULL,
                       Password NVARCHAR(255) NOT NULL,
                       Email NVARCHAR(100) NOT NULL
);

-- Таблиця співробітників
CREATE TABLE Employees (
                           EmployeeId INT IDENTITY(1,1) PRIMARY KEY,
                           UserId INT NOT NULL,
                           RoleId INT NOT NULL,
                           HireDate DATETIME NOT NULL,
                           IsActive BIT DEFAULT 1
);

-- Таблиця ролей співробітників
CREATE TABLE EmployeeRoles (
                               RoleId INT IDENTITY(1,1) PRIMARY KEY,
                               RoleName NVARCHAR(50) NOT NULL UNIQUE,
                               Description NVARCHAR(255) NULL
);

-- Таблиця складів
CREATE TABLE Warehouses (
                            WarehouseId INT IDENTITY(1,1) PRIMARY KEY,
                            Address NVARCHAR(255) NOT NULL,
                            Capacity INT NOT NULL,
                            CurrentLoad INT DEFAULT 0,
                            RegionId INT NOT NULL
);

-- Таблиця посилок
CREATE TABLE Packages (
                          PackageId INT IDENTITY(1,1) PRIMARY KEY,
                          SenderId INT NOT NULL,
                          ReceiverId INT NOT NULL,
                          CurrentStatusId INT NOT NULL,
                          ShippingMethodId INT NOT NULL,
                          WarehouseId INT,
                          CreatedAt DATETIME DEFAULT GETDATE()
);

-- Таблиця страхування посилок
CREATE TABLE PackageInsurance (
                                  InsuranceId INT IDENTITY(1,1) PRIMARY KEY,
                                  PackageId INT NOT NULL,
                                  InsuranceValue DECIMAL(10, 2) NOT NULL,
                                  PremiumAmount DECIMAL(10, 2) NOT NULL,
                                  CoverageDetails NVARCHAR(255)
);

-- Таблиця інцидентів
CREATE TABLE IncidentReports (
                                 ReportId INT IDENTITY(1,1) PRIMARY KEY,
                                 UserId INT NOT NULL,
                                 PackageId INT,
                                 ReportType NVARCHAR(50) CHECK (ReportType IN (N'Пошкодження', N'Втрата', N'Інше')) NOT NULL,
                                 Description NVARCHAR(1000) NOT NULL,
                                 CreatedAt DATETIME DEFAULT GETDATE()
);

-- Таблиця статусів
CREATE TABLE Statuses (
                          StatusId INT IDENTITY(1,1) PRIMARY KEY,
                          StatusName NVARCHAR(50) CHECK (StatusName IN (N'Очікується', N'В дорозі', N'Доставлено', N'Отримано', N'Скасовано')) NOT NULL
);

-- Таблиця методів доставки
CREATE TABLE ShippingMethods (
                                 MethodId INT IDENTITY(1,1) PRIMARY KEY,
                                 MethodName NVARCHAR(50) NOT NULL,
                                 EstimatedDays INT NOT NULL,
                                 Cost DECIMAL(10, 2) NOT NULL
);

-- Таблиця локацій
CREATE TABLE Locations (
                           LocationId INT IDENTITY(1,1) PRIMARY KEY,
                           Address NVARCHAR(255) NOT NULL,
                           City NVARCHAR(100) NOT NULL,
                           PostalCode NVARCHAR(20) NOT NULL
);

-- Таблиця локацій посилок
CREATE TABLE PackageLocations (
                                  PackageLocationId INT IDENTITY(1,1) PRIMARY KEY,
                                  PackageId INT NOT NULL,
                                  LocationId INT NOT NULL,
                                  StatusId INT NOT NULL,
                                  Timestamp DATETIME DEFAULT GETDATE()
);

-- Таблиця платежів
CREATE TABLE Payments (
                          PaymentId INT IDENTITY(1,1) PRIMARY KEY,
                          PackageId INT NOT NULL,
                          Amount DECIMAL(10, 2) NOT NULL,
                          PaymentDate DATETIME DEFAULT GETDATE(),
                          PaymentMethod NVARCHAR(50) CHECK (PaymentMethod IN (N'Кредитна картка', N'Готівка', N'Банківський переказ')) NOT NULL
);

-- Таблиця відгуків
CREATE TABLE Reviews (
                         ReviewId INT IDENTITY(1,1) PRIMARY KEY,
                         UserId INT NOT NULL,
                         PackageId INT NOT NULL,
                         Rating INT CHECK (Rating BETWEEN 1 AND 5),
                         Comment NVARCHAR(500),
                         ReviewDate DATETIME DEFAULT GETDATE()
);

-- Таблиця сповіщень
CREATE TABLE Notifications (
                               NotificationId INT IDENTITY(1,1) PRIMARY KEY,
                               UserId INT NOT NULL,
                               Message NVARCHAR(255) NOT NULL,
                               IsRead BIT DEFAULT 0,
                               CreatedAt DATETIME DEFAULT GETDATE()
);

-- Таблиця адрес
CREATE TABLE Addresses (
                           AddressId INT IDENTITY(1,1) PRIMARY KEY,
                           UserId INT NOT NULL,
                           Address NVARCHAR(255) NOT NULL,
                           City NVARCHAR(100) NOT NULL,
                           PostalCode NVARCHAR(20) NOT NULL,
                           Country NVARCHAR(50) NOT NULL
);