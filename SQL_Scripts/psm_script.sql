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


----test end-----------