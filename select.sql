SELECT * FROM EmployeeRoles;

SELECT * FROM Locations;

SELECT * FROM ServiceRegions;

SELECT * FROM ShippingMethods;

SELECT * FROM Statuses;

SELECT * FROM Users;

SELECT * FROM Addresses;

SELECT * FROM Employees;

SELECT * FROM Notifications;

SELECT * FROM Warehouses;

SELECT * FROM Packages;

SELECT * FROM IncidentReports;

SELECT * FROM PackageInsurance;

SELECT * FROM PackageLocations;

SELECT * FROM Payments;

SELECT * FROM Reviews;


-- Посилки які доставлені або в дорозі з інформацією про відправника отримувача та метод доставки
SELECT
    p.PackageId,
    u1.Username AS Sender,
    u2.Username AS Receiver,
    sm.MethodName AS ShippingMethod,
    s.StatusName AS CurrentStatus,
    p.CreatedAt
FROM Packages p
         JOIN Users u1 ON p.SenderId = u1.UserId
         JOIN Users u2 ON p.ReceiverId = u2.UserId
         JOIN ShippingMethods sm ON p.ShippingMethodId = sm.MethodId
         JOIN Statuses s ON p.CurrentStatusId = s.StatusId
WHERE s.StatusName IN (N'Доставлено', N'В дорозі')
ORDER BY p.CreatedAt DESC;

-- Найновіші відгуки про посилки із рейтингом 4 і вище
SELECT
    r.ReviewId,
    u.Username AS Reviewer,
    r.Rating,
    r.Comment,
    r.ReviewDate
FROM Reviews r
         JOIN Users u ON r.UserId = u.UserId
WHERE r.Rating >= 4
ORDER BY r.ReviewDate DESC;

-- Інциденти, що стосуються втрачених або пошкоджених посилок
SELECT
    ir.ReportId,
    u.Username AS Reporter,
    ir.ReportType,
    ir.Description,
    p.PackageId,
    ir.CreatedAt
FROM IncidentReports ir
         JOIN Users u ON ir.UserId = u.UserId
         LEFT JOIN Packages p ON ir.PackageId = p.PackageId
WHERE ir.ReportType IN (N'Втрата', N'Пошкодження')
ORDER BY ir.CreatedAt DESC;

-- Списки посилок, що зберігаються на складах з поточним завантаженням більше 50%
SELECT
    p.PackageId,
    w.Address AS WarehouseAddress,
    sr.RegionName AS Region,
    w.CurrentLoad,
    w.Capacity,
    ROUND((CAST(w.CurrentLoad AS FLOAT) / w.Capacity) * 100, 2) AS LoadPercentage
FROM Packages p
         JOIN Warehouses w ON p.WarehouseId = w.WarehouseId
         JOIN ServiceRegions sr ON w.RegionId = sr.RegionId
WHERE (CAST(w.CurrentLoad AS FLOAT) / w.Capacity) > 0.5
ORDER BY LoadPercentage DESC;

-- Інформація про посилки із застрахованою вартістю більше 1000 грн
SELECT
    p.PackageId,
    sm.MethodName AS ShippingMethod,
    pi.InsuranceValue,
    pi.PremiumAmount,
    s.StatusName AS CurrentStatus,
    p.CreatedAt
FROM Packages p
         JOIN ShippingMethods sm ON p.ShippingMethodId = sm.MethodId
         JOIN PackageInsurance pi ON p.PackageId = pi.PackageId
         JOIN Statuses s ON p.CurrentStatusId = s.StatusId
WHERE pi.InsuranceValue > 1000
ORDER BY pi.InsuranceValue DESC;