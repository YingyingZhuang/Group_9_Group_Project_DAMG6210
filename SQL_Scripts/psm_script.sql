Use RestaurantManagementSystem;
GO

-- Stored Procedure 1: Create Order
-- Description: Creates a new restaurant order with order items


-- Drop procedure if exists to ensure re-runability
DROP PROCEDURE IF EXISTS sp_CreateOrder;
GO

CREATE OR ALTER PROCEDURE sp_CreateOrder
    -- Input Parameters
    @CustomerID INT,
    @RestaurantID INT,
    @TableID INT,
    @MenuItemID INT,
    @Quantity INT,
    @PaymentInfo VARCHAR(20),
    @Tip DECIMAL(10,2) = 0,
    
    -- Output Parameters
    @OrderID INT OUTPUT,
    @StatusMessage VARCHAR(200) OUTPUT
AS
BEGIN
    
    -- Declare local variables
    DECLARE @UnitPrice DECIMAL(10,2);
    DECLARE @Subtotal DECIMAL(10,2);
    DECLARE @Tax DECIMAL(10,2);
    DECLARE @TransactionAmount DECIMAL(10,2);
    DECLARE @TableStatus VARCHAR(20);
    DECLARE @ErrorOccurred BIT = 0;
    
    -- Initialize output parameters
    SET @OrderID = NULL;
    SET @StatusMessage = '';
    
    -- Begin transaction
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Validation 1: Check if customer exists
        IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CustomerID = @CustomerID)
        BEGIN
            SET @StatusMessage = 'Error: Customer does not exist';
            SET @ErrorOccurred = 1;
        END
        
        -- Validation 2: Check if restaurant exists
        ELSE IF NOT EXISTS (SELECT 1 FROM RESTAURANT WHERE RestaurantID = @RestaurantID)
        BEGIN
            SET @StatusMessage = 'Error: Restaurant does not exist';
            SET @ErrorOccurred = 1;
        END
        
        -- Validation 3: Check if table exists and get its status
        ELSE
        BEGIN
            SELECT @TableStatus = [Status]
            FROM [TABLE]
            WHERE Table_ID = @TableID AND RestaurantID = @RestaurantID;
            
            IF @TableStatus IS NULL
            BEGIN
                SET @StatusMessage = 'Error: Table does not exist';
                SET @ErrorOccurred = 1;
            END
            ELSE IF @TableStatus = 'Occupied'
            BEGIN
                SET @StatusMessage = 'Error: Table is currently occupied';
                SET @ErrorOccurred = 1;
            END
        END
        
        -- Validation 4: Check if menu item exists and get price
        IF @ErrorOccurred = 0
        BEGIN
            SELECT @UnitPrice = Price
            FROM MENUITEM
            WHERE MenuItemID = @MenuItemID;
            
            IF @UnitPrice IS NULL
            BEGIN
                SET @StatusMessage = 'Error: Menu item does not exist';
                SET @ErrorOccurred = 1;
            END
        END
        
        -- Execute business logic only if no validation errors occurred
        IF @ErrorOccurred = 0
        BEGIN
            -- Calculate order amounts
            SET @Subtotal = @Quantity * @UnitPrice;
            SET @Tax = @Subtotal * 0.0625;  -- Apply 6.25% tax rate
            SET @TransactionAmount = @Subtotal;
            
            -- Insert new order into ORDER table
            INSERT INTO [ORDER] (
                OrderDateTime, 
                [Status], 
                PaymentInfo, 
                Transaction_Amount, 
                Tip, 
                Tax, 
                CustomerID, 
                RestaurantID, 
                TableID
            )
            VALUES (
                GETDATE(), 
                'Pending', 
                @PaymentInfo, 
                @TransactionAmount, 
                @Tip, 
                @Tax, 
                @CustomerID, 
                @RestaurantID, 
                @TableID
            );
            
            -- Retrieve the newly created OrderID
            SET @OrderID = SCOPE_IDENTITY();
            
            -- Insert order item details into ORDERITEM table
            INSERT INTO ORDERITEM (Quantity, UnitPrice, OrderID, MenuItemID)
            VALUES (@Quantity, @UnitPrice, @OrderID, @MenuItemID);
            
            -- Update table status to Occupied
            UPDATE [TABLE]
            SET [Status] = 'Occupied'
            WHERE Table_ID = @TableID;
            
            -- Commit transaction if all operations succeeded
            COMMIT TRANSACTION;
            
            SET @StatusMessage = 'Success: Order created with OrderID ' + CAST(@OrderID AS VARCHAR);
        END
        ELSE
        BEGIN
            -- Rollback transaction if validation failed
            ROLLBACK TRANSACTION;
        END
        
    END TRY
    BEGIN CATCH
        -- Rollback transaction on any unexpected error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Capture error details
        SET @StatusMessage = 'Error: ' + ERROR_MESSAGE();
        SET @OrderID = NULL;
        
    END CATCH
END
GO


-----test for sp_createorder---
----!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!------
---- will add a new row in order and orderitem and change the status of table-----
----!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!------
DECLARE @NewOrderID INT;
DECLARE @Message NVARCHAR(200);

EXEC sp_CreateOrder
    @CustomerID = 1,
    @RestaurantID = 1,
    @TableID = 1,
    @MenuItemID = 1,
    @Quantity = 2,
    @PaymentInfo = 'Credit Card',
    @Tip = 5.00,
    @OrderID = @NewOrderID OUTPUT,
    @StatusMessage = @Message OUTPUT;

--see the execution result
SELECT @NewOrderID AS OrderID, @Message AS StatusMessage;

--check new order and new order item
SELECT * FROM [ORDER] WHERE OrderID = @NewOrderID;
SELECT * FROM ORDERITEM WHERE OrderID = @NewOrderID;

------------test sp_createorder end--------



-- Stored Procedure 2: Complete Order
-- Description: Completes a pending order and releases the table

-- Drop procedure if exists 
DROP PROCEDURE IF EXISTS sp_CompleteOrder;
GO

CREATE OR ALTER PROCEDURE sp_CompleteOrder
    -- Input Parameters
    @OrderID INT,
    
    -- Output Parameters
    @StatusMessage VARCHAR(200) OUTPUT
AS
BEGIN

    
    -- Declare local variables
    DECLARE @OrderStatus VARCHAR(20);
    DECLARE @TableID INT;
    DECLARE @ErrorOccurred BIT = 0;
    
    -- Initialize output parameter
    SET @StatusMessage = '';
    
    -- Begin transaction
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Validation 1: Check if order exists and get current status
        SELECT @OrderStatus = [Status], @TableID = TableID
        FROM [ORDER]
        WHERE OrderID = @OrderID;
        
        IF @OrderStatus IS NULL
        BEGIN
            SET @StatusMessage = 'Error: Order does not exist';
            SET @ErrorOccurred = 1;
        END
        
        -- Validation 2: Check if order is already completed or cancelled
        ELSE IF @OrderStatus = 'Completed'
        BEGIN
            SET @StatusMessage = 'Error: Order is already completed';
            SET @ErrorOccurred = 1;
        END
        ELSE IF @OrderStatus = 'Cancelled'
        BEGIN
            SET @StatusMessage = 'Error: Cannot complete a cancelled order';
            SET @ErrorOccurred = 1;
        END
        
        -- Execute business logic only if no validation errors occurred
        IF @ErrorOccurred = 0
        BEGIN
            -- Update order status to Completed
            UPDATE [ORDER]
            SET [Status] = 'Completed'
            WHERE OrderID = @OrderID;
            
            -- Release the table by updating status to Available
            UPDATE [TABLE]
            SET [Status] = 'Available'
            WHERE Table_ID = @TableID;
            
            -- Commit transaction if all operations succeeded
            COMMIT TRANSACTION;
            
            SET @StatusMessage = 'Success: Order ' + CAST(@OrderID AS VARCHAR) + ' completed and table released';
        END
        ELSE
        BEGIN
            -- Rollback transaction if validation failed
            ROLLBACK TRANSACTION;
        END
        
    END TRY
    BEGIN CATCH
        -- Rollback transaction on any unexpected error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Capture error details
        SET @StatusMessage = 'Error: ' + ERROR_MESSAGE();
        
    END CATCH
END
GO



-----test for sp_CompleteOrder---
----!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!------
---- will update the order status and table status-----
----!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!------

-- get the lastest order and complete it 
DECLARE @Message VARCHAR(200);
DECLARE @LatestOrderID INT;

-- get the lastest pending order
SELECT TOP 1 @LatestOrderID = OrderID 
FROM [ORDER] 
WHERE [Status] = 'Pending'
ORDER BY OrderID DESC;

-- complete it!
EXEC sp_CompleteOrder
    @OrderID = @LatestOrderID,
    @StatusMessage = @Message OUTPUT;

SELECT @Message AS StatusMessage;
------------test sp_createorder end--------



-- Stored Procedure 3: Cancel Order
-- Description: Cancels a pending order and releases the table

-- Drop procedure if exists 
DROP PROCEDURE IF EXISTS sp_CancelOrder;
GO

CREATE PROCEDURE sp_CancelOrder
    -- Input Parameters
    @OrderID INT,
    
    -- Output Parameters
    @StatusMessage VARCHAR(200) OUTPUT
AS
BEGIN
    -- Declare local variables
    DECLARE @OrderStatus VARCHAR(20);
    DECLARE @TableID INT;
    DECLARE @ErrorOccurred BIT = 0;
    
    -- Initialize output parameter
    SET @StatusMessage = '';
    
    -- Begin transaction
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Validation 1: Check if order exists and get current status
        SELECT @OrderStatus = [Status], @TableID = TableID
        FROM [ORDER]
        WHERE OrderID = @OrderID;
        
        IF @OrderStatus IS NULL
        BEGIN
            SET @StatusMessage = 'Error: Order does not exist';
            SET @ErrorOccurred = 1;
        END
        
        -- Validation 2: Check if order can be cancelled
        ELSE IF @OrderStatus = 'Completed'
        BEGIN
            SET @StatusMessage = 'Error: Cannot cancel a completed order';
            SET @ErrorOccurred = 1;
        END
        ELSE IF @OrderStatus = 'Cancelled'
        BEGIN
            SET @StatusMessage = 'Error: Order is already cancelled';
            SET @ErrorOccurred = 1;
        END
        
        -- Execute business logic only if no validation errors occurred
        IF @ErrorOccurred = 0
        BEGIN
            -- Update order status to Cancelled
            UPDATE [ORDER]
            SET [Status] = 'Cancelled'
            WHERE OrderID = @OrderID;
            
            -- Release the table by updating status to Available
            UPDATE [TABLE]
            SET [Status] = 'Available'
            WHERE Table_ID = @TableID;
            
            -- Commit transaction if all operations succeeded
            COMMIT TRANSACTION;
            
            SET @StatusMessage = 'Success: Order ' + CAST(@OrderID AS VARCHAR) + ' cancelled and table released';
        END
        ELSE
        BEGIN
            -- Rollback transaction if validation failed
            ROLLBACK TRANSACTION;
        END
        
    END TRY
    BEGIN CATCH
        -- Rollback transaction on any unexpected error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Capture error details
        SET @StatusMessage = 'Error: ' + ERROR_MESSAGE();
        
    END CATCH
END
GO


-----test for sp_CancelOrder---
----!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!------
---- will update the order and table status-----
----!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!------

DECLARE @Message VARCHAR(200);

-- Test: Cancel order 4 (it's Pending)
EXEC sp_CancelOrder
    @OrderID = 4,
    @StatusMessage = @Message OUTPUT;

SELECT @Message AS StatusMessage;

-- Check the result
SELECT OrderID, [Status], TableID FROM [ORDER] WHERE OrderID = 4;
SELECT Table_ID, [Status] FROM [TABLE] WHERE Table_ID = 6;

------------test sp_CancelOrder end--------
select * from [order]

-- change back order 4 and table 6 for testing
UPDATE [ORDER]
SET [Status] = 'Pending'
WHERE OrderID = 4;

UPDATE [TABLE]
SET [Status] = 'Available'  -- change back
WHERE Table_ID = 6;
-----------recovery end ---------------------



-- Stored Procedure 4: Reserve Table
-- Description: Reserves an available table for a customer

-- Drop procedure if exists
DROP PROCEDURE IF EXISTS sp_ReserveTable;
GO

CREATE PROCEDURE sp_ReserveTable
    -- Input Parameters
    @TableID INT,
    @RestaurantID INT,
    @CustomerID INT,
    
    -- Output Parameters
    @StatusMessage VARCHAR(200) OUTPUT
AS
BEGIN
    -- Declare local variables
    DECLARE @TableStatus VARCHAR(20);
    DECLARE @ErrorOccurred BIT = 0;
    
    -- Initialize output parameter
    SET @StatusMessage = '';
    
    -- Begin transaction
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Validation 1: Check if customer exists
        IF NOT EXISTS (SELECT 1 FROM CUSTOMER WHERE CustomerID = @CustomerID)
        BEGIN
            SET @StatusMessage = 'Error: Customer does not exist';
            SET @ErrorOccurred = 1;
        END
        
        -- Validation 2: Check if restaurant exists
        ELSE IF NOT EXISTS (SELECT 1 FROM RESTAURANT WHERE RestaurantID = @RestaurantID)
        BEGIN
            SET @StatusMessage = 'Error: Restaurant does not exist';
            SET @ErrorOccurred = 1;
        END
        
        -- Validation 3: Check if table exists and get its status
        ELSE
        BEGIN
            SELECT @TableStatus = [Status]
            FROM [TABLE]
            WHERE Table_ID = @TableID AND RestaurantID = @RestaurantID;
            
            IF @TableStatus IS NULL
            BEGIN
                SET @StatusMessage = 'Error: Table does not exist in this restaurant';
                SET @ErrorOccurred = 1;
            END
            ELSE IF @TableStatus != 'Available'
            BEGIN
                SET @StatusMessage = 'Error: Table is not available (Current status: ' + @TableStatus + ')';
                SET @ErrorOccurred = 1;
            END
        END
        
        -- Execute business logic only if no validation errors occurred
        IF @ErrorOccurred = 0
        BEGIN
            -- Update table status to Reserved
            UPDATE [TABLE]
            SET [Status] = 'Reserved'
            WHERE Table_ID = @TableID;
            
            -- Commit transaction if all operations succeeded
            COMMIT TRANSACTION;
            
            SET @StatusMessage = 'Success: Table ' + CAST(@TableID AS VARCHAR) + ' reserved for customer ' + CAST(@CustomerID AS VARCHAR);
        END
        ELSE
        BEGIN
            -- Rollback transaction if validation failed
            ROLLBACK TRANSACTION;
        END
        
    END TRY
    BEGIN CATCH
        -- Rollback transaction on any unexpected error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Capture error details
        SET @StatusMessage = 'Error: ' + ERROR_MESSAGE();
        
    END CATCH
END
GO

-----test for sp_ReserveTable---
----!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!------
---- will update the  table status-----
----!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!------

DECLARE @Message VARCHAR(200);

-- Test: Reserve table 4 for customer 5
EXEC sp_ReserveTable
    @TableID = 4,
    @RestaurantID = 1,
    @CustomerID = 5,
    @StatusMessage = @Message OUTPUT;

SELECT @Message AS StatusMessage;

-- Check the result
SELECT Table_ID, Table_Number, [Status], Seating_Capacity 
FROM [TABLE] 
WHERE Table_ID = 4;

--=====================================------
-- recovery the table 4 for available---
UPDATE [TABLE]
SET [Status] = 'Available'
WHERE Table_ID = 4;


SELECT Table_ID, Table_Number, [Status], Seating_Capacity 
FROM [TABLE] 
WHERE Table_ID = 4;

GO
----test end-----------


-- Function 1: Calculate total revenue for a restaurant in a date range

CREATE OR ALTER FUNCTION dbo.fn_CalculateRestaurantRevenue
(
    @RestaurantID INT,
    @StartDate DATE,
    @EndDate DATE
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10,2);
    
    SELECT @TotalRevenue = SUM(Transaction_Amount + Tax + Tip)
    FROM [ORDER]
    WHERE RestaurantID = @RestaurantID
        AND [Status] = 'Completed'
        AND CAST(OrderDateTime AS DATE) BETWEEN @StartDate AND @EndDate;
    
    -- Return 0 if no orders found
    RETURN ISNULL(@TotalRevenue, 0);
END
GO

-- Test Scalar Function
SELECT 
    RestaurantID,
    Restaurant_name,
    dbo.fn_CalculateRestaurantRevenue(RestaurantID, '2025-11-01', '2025-11-30') AS NovemberRevenue
FROM RESTAURANT
WHERE RestaurantID IN (1, 2, 3, 5);
GO

-- Function 2: Get menu items and their ingredient availability
CREATE OR ALTER FUNCTION dbo.fn_GetMenuItemIngredients
(
    @MenuItemID INT,
    @RestaurantID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        r.RestaurantID,
        r.Restaurant_name,
        m.MenuItemID,
        m.[Name] AS MenuItemName,
        m.Price,
        i.ingredient_id,
        i.[name] AS IngredientName,
        mi.quantity_required AS QuantityNeeded,
        ISNULL(inv.current_quantity, 0) AS CurrentStock,
        i.unit,
        CASE 
            WHEN ISNULL(inv.current_quantity, 0) >= mi.quantity_required THEN 'Available'
            WHEN ISNULL(inv.current_quantity, 0) > 0 THEN 'Low Stock'
            ELSE 'Out of Stock'
        END AS StockStatus
    FROM MENUITEM m
    INNER JOIN MENU_INGREDIENT mi ON m.MenuItemID = mi.MenuItemID
    INNER JOIN INGREDIENT i ON mi.ingredient_id = i.ingredient_id
    LEFT JOIN INVENTORY inv ON i.ingredient_id = inv.ingredient_id 
        AND inv.RestaurantID = @RestaurantID
    INNER JOIN RESTAURANT r ON r.RestaurantID = @RestaurantID
    WHERE m.MenuItemID = @MenuItemID
);
GO

-- Test Inline Table-Valued Function
SELECT * FROM dbo.fn_GetMenuItemIngredients(1, 1);
SELECT * FROM dbo.fn_GetMenuItemIngredients(6, 1);
GO

-- Function 3: Get low stock ingredients that need reordering
CREATE OR ALTER FUNCTION dbo.fn_GetLowStockIngredients
(
    @RestaurantID INT
)
RETURNS @LowStockTable TABLE
(
    RestaurantID INT,
    RestaurantName VARCHAR(100),
    IngredientID INT,
    IngredientName VARCHAR(100),
    Category VARCHAR(50),
    CurrentQuantity DECIMAL(10,2),
    ReorderLevel DECIMAL(10,2),
    Unit VARCHAR(20),
    StockPercentage DECIMAL(5,2),
    OrderPriority VARCHAR(20),
    LastUpdated DATETIME
)
AS
BEGIN
    DECLARE @RestaurantName VARCHAR(100);
    
    -- Get restaurant name
    SELECT @RestaurantName = Restaurant_name
    FROM RESTAURANT
    WHERE RestaurantID = @RestaurantID;
    
    -- Insert ingredients below reorder level
    INSERT INTO @LowStockTable
    SELECT 
        @RestaurantID,
        @RestaurantName,
        i.ingredient_id,
        i.[name],
        i.category,
        ISNULL(inv.current_quantity, 0) AS CurrentQuantity,
        i.reorder_level,
        i.unit,
        CASE 
            WHEN i.reorder_level > 0 
            THEN ROUND((ISNULL(inv.current_quantity, 0) / i.reorder_level) * 100, 2)
            ELSE 100.00
        END AS StockPercentage,
        CASE 
            WHEN ISNULL(inv.current_quantity, 0) = 0 THEN 'URGENT'
            WHEN ISNULL(inv.current_quantity, 0) < (i.reorder_level * 0.5) THEN 'High'
            ELSE 'Medium'
        END AS OrderPriority,
        inv.last_updated
    FROM INGREDIENT i
    LEFT JOIN INVENTORY inv ON i.ingredient_id = inv.ingredient_id 
        AND inv.RestaurantID = @RestaurantID
    WHERE ISNULL(inv.current_quantity, 0) <= i.reorder_level;
    
    RETURN;
END
GO

-- Test Multi-Statement Table-Valued Function
SELECT * FROM dbo.fn_GetLowStockIngredients(1)
ORDER BY OrderPriority DESC, StockPercentage ASC;

SELECT * FROM dbo.fn_GetLowStockIngredients(2)
ORDER BY OrderPriority DESC;
GO

-- ==========================================
-- VIEW 1: Restaurant Sales Summary
-- ==========================================
-- Purpose: Provides a comprehensive sales overview for each restaurant
-- Use Cases: Management reporting, performance comparison, revenue tracking

DROP VIEW IF EXISTS vw_RestaurantSalesSummary;
GO

CREATE VIEW vw_RestaurantSalesSummary
AS
SELECT 
    r.RestaurantID,
    r.Restaurant_name,
    r.city,
    r.[state],
    r.[status],
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COUNT(DISTINCT CASE WHEN o.[Status] = 'Completed' THEN o.OrderID END) AS CompletedOrders,
    COUNT(DISTINCT CASE WHEN o.[Status] = 'Pending' THEN o.OrderID END) AS PendingOrders,
    COUNT(DISTINCT CASE WHEN o.[Status] = 'Cancelled' THEN o.OrderID END) AS CancelledOrders,
    ISNULL(SUM(CASE WHEN o.[Status] = 'Completed' THEN o.Transaction_Amount ELSE 0 END), 0) AS TotalRevenue,
    ISNULL(SUM(CASE WHEN o.[Status] = 'Completed' THEN o.Tax ELSE 0 END), 0) AS TotalTax,
    ISNULL(SUM(CASE WHEN o.[Status] = 'Completed' THEN o.Tip ELSE 0 END), 0) AS TotalTips,
    ISNULL(SUM(CASE WHEN o.[Status] = 'Completed' THEN (o.Transaction_Amount + o.Tax + o.Tip) ELSE 0 END), 0) AS TotalGrossRevenue,
    CASE 
        WHEN COUNT(DISTINCT o.OrderID) > 0 
        THEN ISNULL(SUM(CASE WHEN o.[Status] = 'Completed' THEN (o.Transaction_Amount + o.Tax + o.Tip) ELSE 0 END), 0) / COUNT(DISTINCT CASE WHEN o.[Status] = 'Completed' THEN o.OrderID END)
        ELSE 0 
    END AS AverageOrderValue,
    COUNT(DISTINCT o.CustomerID) AS UniqueCustomers
FROM RESTAURANT r
LEFT JOIN [ORDER] o ON r.RestaurantID = o.RestaurantID
GROUP BY r.RestaurantID, r.Restaurant_name, r.city, r.[state], r.[status];
GO

-- Test View 1
SELECT * FROM vw_RestaurantSalesSummary
ORDER BY TotalGrossRevenue DESC;
GO


-- ==========================================
-- VIEW 2: Inventory Status Report
-- ==========================================
-- Purpose: Shows current inventory levels and identifies items needing reorder
-- Use Cases: Inventory management, purchase order generation, stock monitoring

DROP VIEW IF EXISTS vw_InventoryStatusReport;
GO

CREATE VIEW vw_InventoryStatusReport
AS
SELECT 
    r.RestaurantID,
    r.Restaurant_name,
    r.city,
    i.ingredient_id,
    i.[name] AS IngredientName,
    i.category AS IngredientCategory,
    i.unit,
    ISNULL(inv.current_quantity, 0) AS CurrentQuantity,
    i.reorder_level AS ReorderLevel,
    CASE 
        WHEN i.reorder_level > 0 
        THEN ROUND((ISNULL(inv.current_quantity, 0) / i.reorder_level) * 100, 2)
        ELSE 100.00
    END AS StockPercentage,
    CASE 
        WHEN ISNULL(inv.current_quantity, 0) = 0 THEN 'OUT OF STOCK'
        WHEN ISNULL(inv.current_quantity, 0) < (i.reorder_level * 0.5) THEN 'CRITICAL'
        WHEN ISNULL(inv.current_quantity, 0) <= i.reorder_level THEN 'LOW'
        ELSE 'SUFFICIENT'
    END AS StockStatus,
    CASE 
        WHEN ISNULL(inv.current_quantity, 0) = 0 THEN 1
        WHEN ISNULL(inv.current_quantity, 0) < (i.reorder_level * 0.5) THEN 2
        WHEN ISNULL(inv.current_quantity, 0) <= i.reorder_level THEN 3
        ELSE 4
    END AS PriorityOrder,
    inv.last_updated AS LastUpdated
FROM RESTAURANT r
CROSS JOIN INGREDIENT i
LEFT JOIN INVENTORY inv ON r.RestaurantID = inv.RestaurantID 
    AND i.ingredient_id = inv.ingredient_id
WHERE r.[status] = 'Active';
GO

-- Test View 2
SELECT * FROM vw_InventoryStatusReport
WHERE StockStatus IN ('OUT OF STOCK', 'CRITICAL', 'LOW')
ORDER BY RestaurantID, PriorityOrder;
GO


-- ==========================================
-- VIEW 3: Menu Item Performance Analysis
-- ==========================================
-- Purpose: Analyzes menu item popularity and revenue contribution
-- Use Cases: Menu optimization, pricing strategy, inventory planning

DROP VIEW IF EXISTS vw_MenuItemPerformance;
GO

CREATE VIEW vw_MenuItemPerformance
AS
SELECT 
    m.MenuItemID,
    m.[Name] AS MenuItemName,
    m.Category,
    m.Price AS MenuPrice,
    COUNT(DISTINCT oi.OrderID) AS TimesOrdered,
    SUM(oi.Quantity) AS TotalQuantitySold,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue,
    AVG(oi.UnitPrice) AS AverageSellingPrice,
    COUNT(DISTINCT o.RestaurantID) AS RestaurantsServed,
    MIN(o.OrderDateTime) AS FirstOrderDate,
    MAX(o.OrderDateTime) AS LastOrderDate,
    CASE 
        WHEN SUM(oi.Quantity) >= 20 THEN 'High Demand'
        WHEN SUM(oi.Quantity) >= 10 THEN 'Medium Demand'
        WHEN SUM(oi.Quantity) >= 5 THEN 'Low Demand'
        ELSE 'Very Low Demand'
    END AS DemandLevel,
    DENSE_RANK() OVER (ORDER BY SUM(oi.Quantity * oi.UnitPrice) DESC) AS RevenueRank,
    DENSE_RANK() OVER (PARTITION BY m.Category ORDER BY SUM(oi.Quantity) DESC) AS CategoryPopularityRank
FROM MENUITEM m
LEFT JOIN ORDERITEM oi ON m.MenuItemID = oi.MenuItemID
LEFT JOIN [ORDER] o ON oi.OrderID = o.OrderID AND o.[Status] = 'Completed'
GROUP BY m.MenuItemID, m.[Name], m.Category, m.Price;
GO

-- Test View 3
SELECT * FROM vw_MenuItemPerformance
ORDER BY TotalRevenue DESC;

-- Popular items by category
SELECT * FROM vw_MenuItemPerformance
WHERE CategoryPopularityRank <= 3
ORDER BY Category, CategoryPopularityRank;
GO

-- triggers---
-- Create or modify the trigger: Prevent the deletion of customers who have placed previous orders
CREATE OR ALTER TRIGGER trg_PreventCustomerDeletion
ON CUSTOMER
INSTEAD OF DELETE  -- 'INSTEAD OF' trigger, which takes over the operation before executing DELETE
AS
BEGIN
    -- 1. Check whether the customer to be deleted has any records in the [ORDER] table
    IF EXISTS (
        SELECT 1 
        FROM [ORDER] o
        INNER JOIN deleted d ON o.CustomerID = d.CustomerID
    )
    BEGIN
        -- 2. Check whether the customer to be deleted has any records in the [ORDER] table. If there are order records, throw an error and roll back .
        -- 16 represents the error level, and 1 is the status code.
        RAISERROR ('Business Rule Violation: Cannot delete customer with existing order history. Deletion is blocked.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    ELSE
    BEGIN
        -- 3.If there is no order record, then execute the native DELETE operation
        DELETE FROM CUSTOMER
        WHERE CustomerID IN (SELECT CustomerID FROM deleted);
    END
END;
GO

-- Attempt to delete customers who have orders (it should fail and give an error message)
DELETE FROM CUSTOMER WHERE CustomerID = 1; 
GO

-- Insert a new customer (with no order)
INSERT INTO CUSTOMER (Phone, Email, Street, City, [State], zip_code)
VALUES ('617-555-9999', 'noorder@email.com', '123 Test St', 'Boston', 'MA', '02101');
GO

-- Delete the latest inserted customer (assuming its ID is SCOPE_IDENTITY(), which is 11)
DELETE FROM CUSTOMER WHERE CustomerID = SCOPE_IDENTITY();
GO

--  Check the CUSTOMER table to see if the customer has been removed
SELECT * FROM CUSTOMER WHERE Email = 'noorder@email.com';
GO

-- trigger 2: Automated Inventory Reduction
CREATE OR ALTER TRIGGER trg_AutoDecrementInventory
ON ORDERITEM
AFTER INSERT
AS
BEGIN

    SET NOCOUNT ON;

    -- check if there is sufficient inventory in the INVENTORY table
    UPDATE inv
    SET current_quantity = inv.current_quantity - (i.Quantity * mi.quantity_required),
        last_updated = GETDATE()
    FROM INVENTORY inv
    INNER JOIN INGREDIENT ing ON inv.ingredient_id = ing.ingredient_id
    INNER JOIN MENU_INGREDIENT mi ON ing.ingredient_id = mi.ingredient_id
    INNER JOIN inserted i ON mi.MenuItemID = i.MenuItemID
    INNER JOIN [ORDER] o ON i.OrderID = o.OrderID 
    WHERE inv.ingredient_id = mi.ingredient_id 
      AND inv.RestaurantID = o.RestaurantID; 

END
GO