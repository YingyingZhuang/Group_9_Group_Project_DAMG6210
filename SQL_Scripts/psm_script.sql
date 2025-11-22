Use RestaurantManagementSystem;
GO

-- Stored Procedure 1: Create Order
-- Description: Creates a new restaurant order with order items,
--              includes transaction management and error handling

CREATE PROCEDURE sp_CreateOrder
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
    SET NOCOUNT ON;
    
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

------------test end--------