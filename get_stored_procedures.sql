CREATE OR ALTER PROCEDURE dbo.sp_GetStatuses
    @StatusName NVARCHAR(50) = NULL,
    @PageSize INT = 20,
    @PageNumber INT = 1,
    @SortColumn NVARCHAR(128) = 'StatusName',
    @SortDirection BIT = 0
AS
BEGIN
    SELECT StatusId, StatusName
    FROM Statuses
    WHERE (@StatusName IS NULL OR StatusName LIKE '%' + @StatusName + '%')
    ORDER BY
        CASE WHEN @SortDirection = 0 THEN
                 CASE @SortColumn
                     WHEN 'StatusId' THEN CAST(StatusId AS NVARCHAR)
                     WHEN 'StatusName' THEN StatusName
                     END
            END ASC,
        CASE WHEN @SortDirection = 1 THEN
                 CASE @SortColumn
                     WHEN 'StatusId' THEN CAST(StatusId AS NVARCHAR)
                     WHEN 'StatusName' THEN StatusName
                     END
            END DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END;

EXEC dbo.sp_GetStatuses @PageSize = 3, @PageNumber = 1, @SortColumn = N'StatusName', @SortDirection = 1;


CREATE OR ALTER PROCEDURE dbo.sp_GetShippingMethods
    @MethodName NVARCHAR(50) = NULL,
    @PageSize INT = 20,
    @PageNumber INT = 1,
    @SortColumn NVARCHAR(128) = 'MethodName',
    @SortDirection BIT = 0
AS
BEGIN
    SELECT MethodId, MethodName, EstimatedDays, Cost
    FROM ShippingMethods
    WHERE (@MethodName IS NULL OR MethodName LIKE '%' + @MethodName + '%')
    ORDER BY
        CASE WHEN @SortDirection = 0 THEN
                 CASE @SortColumn
                     WHEN 'MethodId' THEN CAST(MethodId AS NVARCHAR)
                     WHEN 'MethodName' THEN MethodName
                     WHEN 'Cost' THEN CAST(Cost AS NVARCHAR)
                     WHEN 'EstimatedDays' THEN CAST(EstimatedDays AS NVARCHAR)
                     END
            END ASC,
        CASE WHEN @SortDirection = 1 THEN
                 CASE @SortColumn
                     WHEN 'MethodId' THEN CAST(MethodId AS NVARCHAR)
                     WHEN 'MethodName' THEN MethodName
                     WHEN 'Cost' THEN CAST(Cost AS NVARCHAR)
                     WHEN 'EstimatedDays' THEN CAST(EstimatedDays AS NVARCHAR)
                     END
            END DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END;

EXEC dbo.sp_GetShippingMethods @PageSize = 10, @PageNumber = 1, @SortColumn = N'EstimatedDays', @SortDirection = 0;


CREATE OR ALTER PROCEDURE dbo.sp_GetEmployeeRoles
    @RoleName NVARCHAR(50) = NULL,
    @PageSize INT = 20,
    @PageNumber INT = 1,
    @SortColumn NVARCHAR(128) = 'RoleName',
    @SortDirection BIT = 0
AS
BEGIN
    SELECT RoleId, RoleName, Description
    FROM EmployeeRoles
    WHERE (@RoleName IS NULL OR RoleName LIKE '%' + @RoleName + '%')
    ORDER BY
        CASE WHEN @SortDirection = 0 THEN
                 CASE @SortColumn
                     WHEN 'RoleId' THEN CAST(RoleId AS NVARCHAR)
                     WHEN 'RoleName' THEN RoleName
                     WHEN 'Description' THEN Description
                     END
            END ASC,
        CASE WHEN @SortDirection = 1 THEN
                 CASE @SortColumn
                     WHEN 'RoleId' THEN CAST(RoleId AS NVARCHAR)
                     WHEN 'RoleName' THEN RoleName
                     WHEN 'Description' THEN Description
                     END
            END DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END;

EXEC dbo.sp_GetEmployeeRoles @PageSize = 5, @PageNumber = 1, @SortColumn = 'RoleId', @SortDirection = 1;


CREATE OR ALTER PROCEDURE dbo.sp_GetServiceRegions
    @RegionName NVARCHAR(50) = NULL,
    @PageSize INT = 20,
    @PageNumber INT = 1,
    @SortColumn NVARCHAR(128) = 'RegionName',
    @SortDirection BIT = 0
AS
BEGIN
    SELECT RegionId, RegionName
    FROM ServiceRegions
    WHERE (@RegionName IS NULL OR RegionName LIKE '%' + @RegionName + '%')
    ORDER BY
        CASE WHEN @SortDirection = 0 THEN
                 CASE @SortColumn
                     WHEN 'RegionId' THEN CAST(RegionId AS NVARCHAR)
                     WHEN 'RegionName' THEN RegionName
                     END
            END ASC,
        CASE WHEN @SortDirection = 1 THEN
                 CASE @SortColumn
                     WHEN 'RegionId' THEN CAST(RegionId AS NVARCHAR)
                     WHEN 'RegionName' THEN RegionName
                     END
            END DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
END;

EXEC sp_GetServiceRegions @RegionName = N'Київська'