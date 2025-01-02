-- Оформлення нової посилки
CREATE PROCEDURE sp_CreatePackage
    @SenderId INT,
    @ReceiverId INT,
    @ShippingMethodId INT,
    @WarehouseId INT = NULL,
    @InsuranceValue DECIMAL(10, 2) = NULL,
    @InsurancePremium DECIMAL(10, 2) = NULL,
    @CoverageDetails NVARCHAR(255) = NULL,
    @PackageId INT OUTPUT
AS
BEGIN
    DECLARE @StatusId INT = (SELECT StatusId FROM Statuses WHERE StatusName = N'Очікується');

    EXEC sp_SetPackage
         @PackageId = @PackageId OUTPUT,
         @SenderId = @SenderId,
         @ReceiverId = @ReceiverId,
         @CurrentStatusId = @StatusId,
         @ShippingMethodId = @ShippingMethodId,
         @WarehouseId = @WarehouseId;

    IF @InsuranceValue IS NOT NULL AND @InsurancePremium IS NOT NULL
        BEGIN
            DECLARE @InsuranceId INT;
            EXEC sp_SetPackageInsurance
                 @InsuranceId = @InsuranceId OUTPUT,
                 @PackageId = @PackageId,
                 @InsuranceValue = @InsuranceValue,
                 @PremiumAmount = @InsurancePremium,
                 @CoverageDetails = @CoverageDetails;
        END
END;
GO

DECLARE @NewPackageId INT;
EXEC sp_CreatePackage
     @SenderId = 1,
     @ReceiverId = 2,
     @ShippingMethodId = 3,
     @WarehouseId = 1,
     @InsuranceValue = 1000.00,
     @InsurancePremium = 50.00,
     @CoverageDetails = N'Full coverage',
     @PackageId = @NewPackageId OUTPUT;
PRINT 'New PackageId: ' + CAST(@NewPackageId AS NVARCHAR);


-- Оновлення статусу посилки
CREATE PROCEDURE sp_UpdatePackageStatus
    @PackageId INT,
    @NewStatusName NVARCHAR(50),
    @LocationId INT = NULL
AS
BEGIN
    DECLARE @NewStatusId INT;
    SELECT @NewStatusId = StatusId FROM Statuses WHERE StatusName = @NewStatusName;

    IF @NewStatusId IS NULL
        BEGIN
            RAISERROR(N'Статус "%s" не знайдено.', 16, 1, @NewStatusName);
            RETURN;
        END

    EXEC sp_SetPackage
         @PackageId = @PackageId,
         @CurrentStatusId = @NewStatusId;

    IF @LocationId IS NOT NULL
        BEGIN
            DECLARE @PackageLocationId INT;
            EXEC sp_SetPackageLocation
                 @PackageLocationId = @PackageLocationId OUTPUT,
                 @PackageId = @PackageId,
                 @LocationId = @LocationId,
                 @StatusId = @NewStatusId;
        END
END;
GO

DECLARE @NewStatusId INT;
EXEC sp_UpdatePackageStatus
     @PackageId = 1,
     @NewStatusName = N'Доставлено',
     @LocationId = 2;
PRINT 'New StatusId: ' + CAST(@NewStatusId AS NVARCHAR);


-- Оплата посилки
CREATE PROCEDURE sp_MakePayment
    @PackageId INT,
    @Amount DECIMAL(10, 2),
    @PaymentMethod NVARCHAR(50)
AS
BEGIN
    DECLARE @PaymentId INT;
    EXEC sp_SetPayment
         @PaymentId = @PaymentId OUTPUT,
         @PackageId = @PackageId,
         @Amount = @Amount,
         @PaymentMethod = @PaymentMethod;

    DECLARE @StatusId INT = (SELECT StatusId FROM Statuses WHERE StatusName = N'Оплачено');
    EXEC sp_SetPackage
         @PackageId = @PackageId,
         @CurrentStatusId = @StatusId;
END;
GO

DECLARE @NewPaymentId INT;
EXEC sp_MakePayment
     @PackageId = 3,
     @Amount = 100.00,
     @PaymentMethod = N'Готівка';
PRINT 'New PaymentId: ' + CAST(@NewPaymentId AS NVARCHAR);


-- Опис інциденту та зміна статусу посилки
CREATE PROCEDURE sp_ReportIncident
    @UserId INT,
    @PackageId INT,
    @ReportType NVARCHAR(50),
    @Description NVARCHAR(1000)
AS
BEGIN
    DECLARE @ReportId INT;
    EXEC sp_SetIncidentReport
         @ReportId = @ReportId OUTPUT,
         @UserId = @UserId,
         @PackageId = @PackageId,
         @ReportType = @ReportType,
         @Description = @Description;

    DECLARE @StatusId INT = (SELECT StatusId FROM Statuses WHERE StatusName = N'Скасовано');
    EXEC sp_SetPackage
         @PackageId = @PackageId,
         @CurrentStatusId = @StatusId;
END;
GO

DECLARE @NewReportId INT;
EXEC sp_ReportIncident
     @UserId = 1,
     @PackageId = 1,
     @ReportType = N'Пошкодження',
    @Description = N'Пакет було пошкоджено під час транспортування.';
PRINT 'New ReportId: ' + CAST(@NewReportId AS NVARCHAR);