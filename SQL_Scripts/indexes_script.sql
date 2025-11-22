USE RestaurantManagementSystem;
GO

-- create index if it does not already exist
-- Restaurant name index
IF NOT EXISTS (SELECT 1 FROM sys.indexes i WHERE i.name = 'idx_restaurant_name' AND i.object_id = OBJECT_ID('dbo.RESTAURANT'))
BEGIN
    CREATE NONCLUSTERED INDEX idx_restaurant_name ON dbo.RESTAURANT (Restaurant_name);
END
GO

-- Customer ID index
IF NOT EXISTS (SELECT 1 FROM sys.indexes i WHERE i.name = 'idx_customer_id' AND i.object_id = OBJECT_ID('dbo.Customer'))
BEGIN
    CREATE NONCLUSTERED INDEX idx_customer_id ON dbo.Customer (CustomerID);
END
GO

-- Order Date index on ORDER table
IF NOT EXISTS (SELECT 1 FROM sys.indexes i WHERE i.name = 'idx_restaurant_orderdate' AND i.object_id = OBJECT_ID('dbo.[ORDER]'))
BEGIN
    CREATE NONCLUSTERED INDEX idx_restaurant_orderdate ON dbo.[ORDER] (RestaurantID, OrderDateTime);
END
GO

-- Employee name index
IF NOT EXISTS (SELECT 1 FROM sys.indexes i WHERE i.name = 'idx_employee_name' AND i.object_id = OBJECT_ID('dbo.EMPLOYEES'))
BEGIN
    CREATE NONCLUSTERED INDEX idx_emp_lastname ON dbo.EMPLOYEES (Name);
END
GO

-- Menu item category index
IF NOT EXISTS (SELECT 1 FROM sys.indexes i WHERE i.name = 'idx_menuitem_category' AND i.object_id = OBJECT_ID('dbo.MENUITEM'))
BEGIN
    CREATE NONCLUSTERED INDEX idx_menuitem_category ON dbo.MENUITEM (category);
END
GO

-- Inventory ingredient_id index
IF NOT EXISTS (SELECT 1 FROM sys.indexes i WHERE i.name = 'idx_inventory_ingredientid' AND i.object_id = OBJECT_ID('dbo.INVENTORY'))
BEGIN
    CREATE NONCLUSTERED INDEX idx_inventory_ingredientid ON dbo.INVENTORY (ingredient_id);
END
GO

-- Expense date index
IF NOT EXISTS (SELECT 1 FROM sys.indexes i WHERE i.name = 'idx_expense_date' AND i.object_id = OBJECT_ID('dbo.EXPENSE'))
BEGIN
    CREATE NONCLUSTERED INDEX idx_expense_date ON dbo.EXPENSE (expense_date);
END
GO

-- OrderItem OrderID index
IF NOT EXISTS (SELECT 1 FROM sys.indexes i WHERE i.name = 'idx_orderitem_orderid' AND i.object_id = OBJECT_ID('dbo.ORDERITEM'))
BEGIN
    CREATE NONCLUSTERED INDEX idx_orderitem_orderid ON dbo.ORDERITEM (OrderID);
END
GO