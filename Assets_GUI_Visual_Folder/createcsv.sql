USE RestaurantManagementSystem;
GO
SELECT RestaurantID, Restaurant_name, city, [state] FROM RESTAURANT;

SELECT MenuItemID, [Name], Price, Category FROM MENUITEM;

SELECT CustomerID, Email, Phone FROM CUSTOMER;

SELECT OrderID, OrderDateTime, [Status], Transaction_Amount, Tip, Tax, CustomerID, RestaurantID FROM [ORDER] WHERE [Status] = 'Completed';

SELECT OrderItemID, Quantity, UnitPrice, OrderID, MenuItemID FROM ORDERITEM;

SELECT * FROM dbo.fn_GetLowStockIngredients(1);

SELECT vendor_id, [name] AS VendorName, city FROM VENDOR;

SELECT expense_id, expense_date, amount, RestaurantID FROM EXPENSE;

SELECT expense_id, vendor_id FROM VENDOR_EXPENSE;

SELECT delivery_id, ingredient_id, quantity_delivered, unit_price FROM DELIVERY_ITEM;

SELECT delivery_id, vendorID, delivery_date FROM SUPPLIER_DELIVERY;