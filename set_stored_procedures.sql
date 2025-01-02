CREATE PROCEDURE sp_SetUser
    @UserId INT = NULL OUTPUT,
    @Username NVARCHAR(50) = NULL,
    @Password NVARCHAR(255) = NULL,
    @Email NVARCHAR(100) = NULL
AS
BEGIN
    IF @UserId IS NULL AND @Username IS NULL AND @Password IS NULL AND @Email IS NULL
        BEGIN
            PRINT N'At least one value must be provided when @UserId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @UserId IS NULL
            BEGIN
                INSERT INTO dbo.Users (Username, Password, Email)
                VALUES (@Username, @Password, @Email);

                SET @UserId = SCOPE_IDENTITY();
                PRINT N'New user record successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @UserId)
                    BEGIN
                        PRINT N'Record with the provided @UserId does not exist.';
                        RETURN;
                    END;

                IF @Username IS NULL AND @Password IS NULL AND @Email IS NULL
                    BEGIN
                        PRINT N'No fields provided for update.';
                        RETURN;
                    END;

                UPDATE dbo.Users
                SET Username = ISNULL(@Username, Username),
                    Password = ISNULL(@Password, Password),
                    Email = ISNULL(@Email, Email)
                WHERE UserId = @UserId;

                PRINT N'User record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

DECLARE @NewUserId INT = 5;
EXEC sp_SetUser @UserId = @NewUserId OUTPUT, @Password = N'securepass', @Email = N'john.doe@example.com';
PRINT 'New UserId: ' + CAST(@NewUserId AS NVARCHAR);


CREATE PROCEDURE sp_SetStatus
    @StatusId INT = NULL OUTPUT,
    @StatusName NVARCHAR(50) = NULL
AS
BEGIN
    IF @StatusId IS NULL AND @StatusName IS NULL
        BEGIN
            PRINT N'At least one value must be provided when @StatusId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @StatusId IS NULL
            BEGIN
                INSERT INTO dbo.Statuses (StatusName)
                VALUES (@StatusName);

                SET @StatusId = SCOPE_IDENTITY();
                PRINT N'New status record successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Statuses WHERE StatusId = @StatusId)
                    BEGIN
                        PRINT N'Record with the provided @StatusId does not exist.';
                        RETURN;
                    END;

                IF @StatusName IS NULL
                    BEGIN
                        PRINT N'No fields provided for update.';
                        RETURN;
                    END;

                UPDATE dbo.Statuses
                SET StatusName = ISNULL(@StatusName, StatusName)
                WHERE StatusId = @StatusId;

                PRINT N'Status record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

DECLARE @StatusId INT = 5;
EXEC sp_SetStatus @StatusName = N'Скасовано', @StatusId = @StatusId OUTPUT;
PRINT 'StatusId: ' + CAST(@StatusId AS NVARCHAR);


CREATE PROCEDURE sp_SetEmployeeRole
    @RoleId INT = NULL OUTPUT,
    @RoleName NVARCHAR(50) = NULL,
    @Description NVARCHAR(255) = NULL
AS
BEGIN
    IF @RoleId IS NULL AND @RoleName IS NULL AND @Description IS NULL
        BEGIN
            PRINT N'At least one value must be provided when @RoleId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @RoleId IS NULL
            BEGIN
                INSERT INTO dbo.EmployeeRoles (RoleName, Description)
                VALUES (@RoleName, @Description);

                SET @RoleId = SCOPE_IDENTITY();
                PRINT N'New employee role record successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.EmployeeRoles WHERE RoleId = @RoleId)
                    BEGIN
                        PRINT N'Record with the provided @RoleId does not exist.';
                        RETURN;
                    END;

                IF @RoleName IS NULL AND @Description IS NULL
                    BEGIN
                        PRINT N'No fields provided for update.';
                        RETURN;
                    END;

                UPDATE dbo.EmployeeRoles
                SET RoleName = ISNULL(@RoleName, RoleName),
                    Description = ISNULL(@Description, Description)
                WHERE RoleId = @RoleId;

                PRINT N'Employee role record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

DECLARE @NewRoleId INT = 4;
EXEC sp_SetEmployeeRole @Description = N'Керує командою', @RoleId = @NewRoleId OUTPUT;
PRINT 'New RoleId: ' + CAST(@NewRoleId AS NVARCHAR);


CREATE PROCEDURE sp_SetReview
    @ReviewId INT = NULL OUTPUT,
    @UserId INT = NULL,
    @PackageId INT = NULL,
    @Rating INT = NULL,
    @Comment NVARCHAR(500) = NULL,
    @ReviewDate DATETIME = NULL
AS
BEGIN
    IF @ReviewId IS NULL AND (@UserId IS NULL OR @PackageId IS NULL OR @Rating IS NULL)
        BEGIN
            PRINT N'At least one value must be provided when @ReviewId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @ReviewId IS NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @UserId)
                    BEGIN
                        PRINT N'User with the provided @UserId does not exist.';
                        RETURN;
                    END;

                IF NOT EXISTS (SELECT 1 FROM dbo.Packages WHERE PackageId = @PackageId)
                    BEGIN
                        PRINT N'Package with the provided @PackageId does not exist.';
                        RETURN;
                    END;

                INSERT INTO dbo.Reviews (UserId, PackageId, Rating, Comment, ReviewDate)
                VALUES (@UserId, @PackageId, @Rating, @Comment, ISNULL(@ReviewDate, GETDATE()));

                SET @ReviewId = SCOPE_IDENTITY();
                PRINT N'New review successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Reviews WHERE ReviewId = @ReviewId)
                    BEGIN
                        PRINT N'Record with the provided @ReviewId does not exist.';
                        RETURN;
                    END;

                IF @UserId IS NULL AND @PackageId IS NULL AND @Rating IS NULL AND @Comment IS NULL AND @ReviewDate IS NULL
                    BEGIN
                        PRINT N'No fields provided for update.';
                        RETURN;
                    END;

                IF @UserId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @UserId)
                    BEGIN
                        PRINT N'User with the provided @UserId does not exist.';
                        RETURN;
                    END;

                IF @PackageId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Packages WHERE PackageId = @PackageId)
                    BEGIN
                        PRINT N'Package with the provided @PackageId does not exist.';
                        RETURN;
                    END;

                UPDATE dbo.Reviews
                SET UserId = ISNULL(@UserId, UserId),
                    PackageId = ISNULL(@PackageId, PackageId),
                    Rating = ISNULL(@Rating, Rating),
                    Comment = ISNULL(@Comment, Comment),
                    ReviewDate = ISNULL(@ReviewDate, ReviewDate)
                WHERE ReviewId = @ReviewId;

                PRINT N'Review record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

DECLARE @NewReviewId INT;
EXEC sp_SetReview @ReviewId = @NewReviewId OUTPUT, @Comment = N'Чудовий сервіс!';
PRINT 'New ReviewId: ' + CAST(@NewReviewId AS NVARCHAR);


CREATE PROCEDURE sp_SetShippingMethod
    @MethodId INT = NULL OUTPUT,
    @MethodName NVARCHAR(50) = NULL,
    @EstimatedDays INT = NULL,
    @Cost DECIMAL(10, 2) = NULL
AS
BEGIN
    IF @MethodId IS NULL AND @MethodName IS NULL AND @EstimatedDays IS NULL AND @Cost IS NULL
        BEGIN
            PRINT N'At least one value must be provided when @MethodId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @MethodId IS NULL
            BEGIN
                INSERT INTO dbo.ShippingMethods (MethodName, EstimatedDays, Cost)
                VALUES (@MethodName, @EstimatedDays, @Cost);

                SET @MethodId = SCOPE_IDENTITY();
                PRINT N'New shipping method record successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.ShippingMethods WHERE MethodId = @MethodId)
                    BEGIN
                        PRINT N'Record with the provided @MethodId does not exist.';
                        RETURN;
                    END;

                IF @MethodName IS NULL AND @EstimatedDays IS NULL AND @Cost IS NULL
                    BEGIN
                        PRINT N'No fields provided for update.';
                        RETURN;
                    END;

                UPDATE dbo.ShippingMethods
                SET MethodName = ISNULL(@MethodName, MethodName),
                    EstimatedDays = ISNULL(@EstimatedDays, EstimatedDays),
                    Cost = ISNULL(@Cost, Cost)
                WHERE MethodId = @MethodId;

                PRINT N'Shipping method record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO


CREATE PROCEDURE sp_SetServiceRegion
    @RegionId INT = NULL OUTPUT,
    @RegionName NVARCHAR(50) = NULL
AS
BEGIN
    IF @RegionId IS NULL AND @RegionName IS NULL
        BEGIN
            PRINT N'At least one value must be provided when @RegionId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @RegionId IS NULL
            BEGIN
                INSERT INTO dbo.ServiceRegions (RegionName)
                VALUES (@RegionName);

                SET @RegionId = SCOPE_IDENTITY();
                PRINT N'New service region record successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.ServiceRegions WHERE RegionId = @RegionId)
                    BEGIN
                        PRINT N'Record with the provided @RegionId does not exist.';
                        RETURN;
                    END;

                IF @RegionName IS NULL
                    BEGIN
                        PRINT N'No fields provided for update.';
                        RETURN;
                    END;

                UPDATE dbo.ServiceRegions
                SET RegionName = ISNULL(@RegionName, RegionName)
                WHERE RegionId = @RegionId;

                PRINT N'Service region record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

CREATE PROCEDURE sp_SetLocation
    @LocationId INT = NULL OUTPUT,
    @Address NVARCHAR(255) = NULL,
    @City NVARCHAR(100) = NULL,
    @PostalCode NVARCHAR(20) = NULL
AS
BEGIN
    IF @LocationId IS NULL AND @Address IS NULL AND @City IS NULL AND @PostalCode IS NULL
        BEGIN
            PRINT N'At least one value must be provided when @LocationId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @LocationId IS NULL
            BEGIN
                INSERT INTO dbo.Locations (Address, City, PostalCode)
                VALUES (@Address, @City, @PostalCode);

                SET @LocationId = SCOPE_IDENTITY();
                PRINT N'New location record successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Locations WHERE LocationId = @LocationId)
                    BEGIN
                        PRINT N'Record with the provided @LocationId does not exist.';
                        RETURN;
                    END;

                IF @Address IS NULL AND @City IS NULL AND @PostalCode IS NULL
                    BEGIN
                        PRINT N'No fields provided for update.';
                        RETURN;
                    END;

                UPDATE dbo.Locations
                SET Address = ISNULL(@Address, Address),
                    City = ISNULL(@City, City),
                    PostalCode = ISNULL(@PostalCode, PostalCode)
                WHERE LocationId = @LocationId;

                PRINT N'Location record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO


CREATE PROCEDURE sp_SetPayment
    @PaymentId INT = NULL OUTPUT,
    @PackageId INT = NULL,
    @Amount DECIMAL(10, 2) = NULL,
    @PaymentDate DATETIME = NULL,
    @PaymentMethod NVARCHAR(50) = NULL
AS
BEGIN
    IF @PaymentId IS NULL AND (@PackageId IS NULL OR @Amount IS NULL OR @PaymentMethod IS NULL)
        BEGIN
            PRINT N'PackageId, Amount, and PaymentMethod must be provided when @PaymentId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @PaymentId IS NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Packages WHERE PackageId = @PackageId)
                    BEGIN
                        PRINT N'Package with the provided @PackageId does not exist.';
                        RETURN;
                    END;

                INSERT INTO dbo.Payments (PackageId, Amount, PaymentDate, PaymentMethod)
                VALUES (@PackageId, @Amount, ISNULL(@PaymentDate, GETDATE()), @PaymentMethod);

                SET @PaymentId = SCOPE_IDENTITY();
                PRINT N'New payment successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE PaymentId = @PaymentId)
                    BEGIN
                        PRINT N'Record with the provided @PaymentId does not exist.';
                        RETURN;
                    END;

                IF @PackageId IS NULL AND @Amount IS NULL AND @PaymentMethod IS NULL AND @PaymentDate IS NULL
                    BEGIN
                        PRINT N'No fields provided for update.';
                        RETURN;
                    END;

                IF @PackageId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Packages WHERE PackageId = @PackageId)
                    BEGIN
                        PRINT N'Package with the provided @PackageId does not exist.';
                        RETURN;
                    END;

                UPDATE dbo.Payments
                SET PackageId = ISNULL(@PackageId, PackageId),
                    Amount = ISNULL(@Amount, Amount),
                    PaymentDate = ISNULL(@PaymentDate, PaymentDate),
                    PaymentMethod = ISNULL(@PaymentMethod, PaymentMethod)
                WHERE PaymentId = @PaymentId;

                PRINT N'Payment record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO


CREATE PROCEDURE sp_SetPackage
    @PackageId INT = NULL OUTPUT,
    @SenderId INT = NULL,
    @ReceiverId INT = NULL,
    @CurrentStatusId INT = NULL,
    @ShippingMethodId INT = NULL,
    @WarehouseId INT = NULL,
    @CreatedAt DATETIME = NULL
AS
BEGIN
    IF @PackageId IS NULL AND (@SenderId IS NULL OR @ReceiverId IS NULL OR @CurrentStatusId IS NULL OR @ShippingMethodId IS NULL)
        BEGIN
            PRINT N'SenderId, ReceiverId, CurrentStatusId, and ShippingMethodId must be provided when @PackageId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @PackageId IS NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @SenderId)
                    BEGIN
                        PRINT N'Sender with the provided @SenderId does not exist.';
                        RETURN;
                    END;

                IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @ReceiverId)
                    BEGIN
                        PRINT N'Receiver with the provided @ReceiverId does not exist.';
                        RETURN;
                    END;

                INSERT INTO dbo.Packages (SenderId, ReceiverId, CurrentStatusId, ShippingMethodId, WarehouseId, CreatedAt)
                VALUES (@SenderId, @ReceiverId, @CurrentStatusId, @ShippingMethodId, @WarehouseId, ISNULL(@CreatedAt, GETDATE()));

                SET @PackageId = SCOPE_IDENTITY();
                PRINT N'New package successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Packages WHERE PackageId = @PackageId)
                    BEGIN
                        PRINT N'Record with the provided @PackageId does not exist.';
                        RETURN;
                    END;

                UPDATE dbo.Packages
                SET SenderId = ISNULL(@SenderId, SenderId),
                    ReceiverId = ISNULL(@ReceiverId, ReceiverId),
                    CurrentStatusId = ISNULL(@CurrentStatusId, CurrentStatusId),
                    ShippingMethodId = ISNULL(@ShippingMethodId, ShippingMethodId),
                    WarehouseId = ISNULL(@WarehouseId, WarehouseId),
                    CreatedAt = ISNULL(@CreatedAt, CreatedAt)
                WHERE PackageId = @PackageId;

                PRINT N'Package record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

CREATE PROCEDURE sp_SetPackageLocation
    @PackageLocationId INT = NULL OUTPUT,
    @PackageId INT = NULL,
    @LocationId INT = NULL,
    @StatusId INT = NULL,
    @Timestamp DATETIME = NULL
AS
BEGIN
    IF @PackageLocationId IS NULL AND (@PackageId IS NULL OR @LocationId IS NULL OR @StatusId IS NULL)
        BEGIN
            PRINT N'PackageId, LocationId, and StatusId must be provided when @PackageLocationId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @PackageLocationId IS NULL
            BEGIN
                INSERT INTO dbo.PackageLocations (PackageId, LocationId, StatusId, Timestamp)
                VALUES (@PackageId, @LocationId, @StatusId, ISNULL(@Timestamp, GETDATE()));

                SET @PackageLocationId = SCOPE_IDENTITY();
                PRINT N'New package location successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.PackageLocations WHERE PackageLocationId = @PackageLocationId)
                    BEGIN
                        PRINT N'Record with the provided @PackageLocationId does not exist.';
                        RETURN;
                    END;

                UPDATE dbo.PackageLocations
                SET PackageId = ISNULL(@PackageId, PackageId),
                    LocationId = ISNULL(@LocationId, LocationId),
                    StatusId = ISNULL(@StatusId, StatusId),
                    Timestamp = ISNULL(@Timestamp, Timestamp)
                WHERE PackageLocationId = @PackageLocationId;

                PRINT N'Package location record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO


CREATE PROCEDURE sp_SetPackageInsurance
    @InsuranceId INT = NULL OUTPUT,
    @PackageId INT = NULL,
    @InsuranceValue DECIMAL(10, 2) = NULL,
    @PremiumAmount DECIMAL(10, 2) = NULL,
    @CoverageDetails NVARCHAR(255) = NULL
AS
BEGIN
    IF @InsuranceId IS NULL AND (@PackageId IS NULL OR @InsuranceValue IS NULL OR @PremiumAmount IS NULL)
        BEGIN
            PRINT N'PackageId, InsuranceValue, and PremiumAmount must be provided when @InsuranceId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @InsuranceId IS NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Packages WHERE PackageId = @PackageId)
                    BEGIN
                        PRINT N'Package with the provided @PackageId does not exist.';
                        RETURN;
                    END;

                INSERT INTO dbo.PackageInsurance (PackageId, InsuranceValue, PremiumAmount, CoverageDetails)
                VALUES (@PackageId, @InsuranceValue, @PremiumAmount, @CoverageDetails);

                SET @InsuranceId = SCOPE_IDENTITY();
                PRINT N'New package insurance successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.PackageInsurance WHERE InsuranceId = @InsuranceId)
                    BEGIN
                        PRINT N'Record with the provided @InsuranceId does not exist.';
                        RETURN;
                    END;

                UPDATE dbo.PackageInsurance
                SET PackageId = ISNULL(@PackageId, PackageId),
                    InsuranceValue = ISNULL(@InsuranceValue, InsuranceValue),
                    PremiumAmount = ISNULL(@PremiumAmount, PremiumAmount),
                    CoverageDetails = ISNULL(@CoverageDetails, CoverageDetails)
                WHERE InsuranceId = @InsuranceId;

                PRINT N'Package insurance record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO


CREATE PROCEDURE sp_SetAddress
    @AddressId INT = NULL OUTPUT,
    @UserId INT = NULL,
    @Address NVARCHAR(255) = NULL,
    @City NVARCHAR(100) = NULL,
    @PostalCode NVARCHAR(20) = NULL,
    @Country NVARCHAR(50) = NULL
AS
BEGIN
    IF @AddressId IS NULL AND (@UserId IS NULL OR @Address IS NULL OR @City IS NULL OR @PostalCode IS NULL OR @Country IS NULL)
        BEGIN
            PRINT N'UserId, Address, City, PostalCode, and Country must be provided when @AddressId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @AddressId IS NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @UserId)
                    BEGIN
                        PRINT N'User with the provided @UserId does not exist.';
                        RETURN;
                    END;

                INSERT INTO dbo.Addresses (UserId, Address, City, PostalCode, Country)
                VALUES (@UserId, @Address, @City, @PostalCode, @Country);

                SET @AddressId = SCOPE_IDENTITY();
                PRINT N'New address successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Addresses WHERE AddressId = @AddressId)
                    BEGIN
                        PRINT N'Record with the provided @AddressId does not exist.';
                        RETURN;
                    END;

                UPDATE dbo.Addresses
                SET UserId = ISNULL(@UserId, UserId),
                    Address = ISNULL(@Address, Address),
                    City = ISNULL(@City, City),
                    PostalCode = ISNULL(@PostalCode, PostalCode),
                    Country = ISNULL(@Country, Country)
                WHERE AddressId = @AddressId;

                PRINT N'Address record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO


CREATE PROCEDURE sp_SetEmployee
    @EmployeeId INT = NULL OUTPUT,
    @UserId INT = NULL,
    @RoleId INT = NULL,
    @HireDate DATETIME = NULL,
    @IsActive BIT = NULL
AS
BEGIN
    IF @EmployeeId IS NULL AND (@UserId IS NULL OR @RoleId IS NULL OR @HireDate IS NULL)
        BEGIN
            PRINT N'UserId, RoleId, and HireDate must be provided when @EmployeeId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @EmployeeId IS NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @UserId)
                    BEGIN
                        PRINT N'User with the provided @UserId does not exist.';
                        RETURN;
                    END;

                IF NOT EXISTS (SELECT 1 FROM dbo.EmployeeRoles WHERE RoleId = @RoleId)
                    BEGIN
                        PRINT N'Role with the provided @RoleId does not exist.';
                        RETURN;
                    END;

                INSERT INTO dbo.Employees (UserId, RoleId, HireDate, IsActive)
                VALUES (@UserId, @RoleId, @HireDate, ISNULL(@IsActive, 1));

                SET @EmployeeId = SCOPE_IDENTITY();
                PRINT N'New employee successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE EmployeeId = @EmployeeId)
                    BEGIN
                        PRINT N'Record with the provided @EmployeeId does not exist.';
                        RETURN;
                    END;

                UPDATE dbo.Employees
                SET UserId = ISNULL(@UserId, UserId),
                    RoleId = ISNULL(@RoleId, RoleId),
                    HireDate = ISNULL(@HireDate, HireDate),
                    IsActive = ISNULL(@IsActive, IsActive)
                WHERE EmployeeId = @EmployeeId;

                PRINT N'Employee record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO


CREATE PROCEDURE sp_SetIncidentReport
    @ReportId INT = NULL OUTPUT,
    @UserId INT = NULL,
    @PackageId INT = NULL,
    @ReportType NVARCHAR(50) = NULL,
    @Description NVARCHAR(1000) = NULL
AS
BEGIN
    IF @ReportId IS NULL AND (@UserId IS NULL OR @ReportType IS NULL OR @Description IS NULL)
        BEGIN
            PRINT N'UserId, ReportType, and Description must be provided when @ReportId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @ReportId IS NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @UserId)
                    BEGIN
                        PRINT N'User with the provided @UserId does not exist.';
                        RETURN;
                    END;

                IF @PackageId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Packages WHERE PackageId = @PackageId)
                    BEGIN
                        PRINT N'Package with the provided @PackageId does not exist.';
                        RETURN;
                    END;

                INSERT INTO dbo.IncidentReports (UserId, PackageId, ReportType, Description, CreatedAt)
                VALUES (@UserId, @PackageId, @ReportType, @Description, GETDATE());

                SET @ReportId = SCOPE_IDENTITY();
                PRINT N'New incident report successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.IncidentReports WHERE ReportId = @ReportId)
                    BEGIN
                        PRINT N'Record with the provided @ReportId does not exist.';
                        RETURN;
                    END;

                UPDATE dbo.IncidentReports
                SET UserId = ISNULL(@UserId, UserId),
                    PackageId = ISNULL(@PackageId, PackageId),
                    ReportType = ISNULL(@ReportType, ReportType),
                    Description = ISNULL(@Description, Description)
                WHERE ReportId = @ReportId;

                PRINT N'Incident report record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO


CREATE PROCEDURE sp_SetNotification
    @NotificationId INT = NULL OUTPUT,
    @UserId INT = NULL,
    @Message NVARCHAR(255) = NULL,
    @IsRead BIT = NULL
AS
BEGIN
    IF @NotificationId IS NULL AND (@UserId IS NULL OR @Message IS NULL)
        BEGIN
            PRINT N'UserId and Message must be provided when @NotificationId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @NotificationId IS NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserId = @UserId)
                    BEGIN
                        PRINT N'User with the provided @UserId does not exist.';
                        RETURN;
                    END;

                INSERT INTO dbo.Notifications (UserId, Message, IsRead, CreatedAt)
                VALUES (@UserId, @Message, ISNULL(@IsRead, 0), GETDATE());

                SET @NotificationId = SCOPE_IDENTITY();
                PRINT N'New notification successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Notifications WHERE NotificationId = @NotificationId)
                    BEGIN
                        PRINT N'Record with the provided @NotificationId does not exist.';
                        RETURN;
                    END;

                UPDATE dbo.Notifications
                SET UserId = ISNULL(@UserId, UserId),
                    Message = ISNULL(@Message, Message),
                    IsRead = ISNULL(@IsRead, IsRead)
                WHERE NotificationId = @NotificationId;

                PRINT N'Notification record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO


CREATE PROCEDURE sp_SetWarehouse
    @WarehouseId INT = NULL OUTPUT,
    @Address NVARCHAR(255) = NULL,
    @Capacity INT = NULL,
    @CurrentLoad INT = NULL,
    @RegionId INT = NULL
AS
BEGIN
    IF @WarehouseId IS NULL AND (@Address IS NULL OR @Capacity IS NULL OR @RegionId IS NULL)
        BEGIN
            PRINT N'Address, Capacity, and RegionId must be provided when @WarehouseId is NULL.';
            RETURN;
        END;

    BEGIN TRY
        IF @WarehouseId IS NULL
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.ServiceRegions WHERE RegionId = @RegionId)
                    BEGIN
                        PRINT N'Region with the provided @RegionId does not exist.';
                        RETURN;
                    END;

                INSERT INTO dbo.Warehouses (Address, Capacity, CurrentLoad, RegionId)
                VALUES (@Address, @Capacity, ISNULL(@CurrentLoad, 0), @RegionId);

                SET @WarehouseId = SCOPE_IDENTITY();
                PRINT N'New warehouse successfully inserted.';
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM dbo.Warehouses WHERE WarehouseId = @WarehouseId)
                    BEGIN
                        PRINT N'Record with the provided @WarehouseId does not exist.';
                        RETURN;
                    END;

                UPDATE dbo.Warehouses
                SET Address = ISNULL(@Address, Address),
                    Capacity = ISNULL(@Capacity, Capacity),
                    CurrentLoad = ISNULL(@CurrentLoad, CurrentLoad),
                    RegionId = ISNULL(@RegionId, RegionId)
                WHERE WarehouseId = @WarehouseId;

                PRINT N'Warehouse record successfully updated.';
            END;
    END TRY
    BEGIN CATCH
        PRINT N'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO