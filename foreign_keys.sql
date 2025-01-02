-- Таблиця співробітників
ALTER TABLE Employees
    ADD FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
        FOREIGN KEY (RoleId) REFERENCES EmployeeRoles(RoleId) ON DELETE CASCADE;

-- Таблиця складів
ALTER TABLE Warehouses
    ADD FOREIGN KEY (RegionId) REFERENCES ServiceRegions(RegionId) ON DELETE CASCADE;

-- Таблиця посилок
ALTER TABLE Packages
    ADD FOREIGN KEY (SenderId) REFERENCES Users(UserId) ON DELETE NO ACTION,
        FOREIGN KEY (ReceiverId) REFERENCES Users(UserId) ON DELETE NO ACTION,
        FOREIGN KEY (CurrentStatusId) REFERENCES Statuses(StatusId) ON DELETE CASCADE,
        FOREIGN KEY (ShippingMethodId) REFERENCES ShippingMethods(MethodId) ON DELETE CASCADE,
        FOREIGN KEY (WarehouseId) REFERENCES Warehouses(WarehouseId);

-- Таблиця страхування посилок
ALTER TABLE PackageInsurance
    ADD FOREIGN KEY (PackageId) REFERENCES Packages(PackageId);

-- Таблиця інцидентів
ALTER TABLE IncidentReports
    ADD FOREIGN KEY (UserId) REFERENCES Users(UserId),
        FOREIGN KEY (PackageId) REFERENCES Packages(PackageId);

-- Таблиця локацій посилок
ALTER TABLE PackageLocations
    ADD FOREIGN KEY (PackageId) REFERENCES Packages(PackageId),
        FOREIGN KEY (LocationId) REFERENCES Locations(LocationId),
        FOREIGN KEY (StatusId) REFERENCES Statuses(StatusId);

-- Таблиця платежів
ALTER TABLE Payments
    ADD FOREIGN KEY (PackageId) REFERENCES Packages(PackageId);

-- Таблиця відгуків
ALTER TABLE Reviews
    ADD FOREIGN KEY (UserId) REFERENCES Users(UserId),
        FOREIGN KEY (PackageId) REFERENCES Packages(PackageId);

-- Таблиця сповіщень
ALTER TABLE Notifications
    ADD FOREIGN KEY (UserId) REFERENCES Users(UserId);

-- Таблиця адрес
ALTER TABLE Addresses
    ADD FOREIGN KEY (UserId) REFERENCES Users(UserId);