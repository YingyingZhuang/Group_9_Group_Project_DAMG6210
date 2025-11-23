USE RestaurantManagementSystem;
GO
SELECT RestaurantID, Restaurant_name, city, [state] FROM RESTAURANT;

SELECT MenuItemID, [Name], Price, Category FROM MENUITEM;

SELECT CustomerID, Email, Phone FROM CUSTOMER;

SELECT OrderID, OrderDateTime, [Status], Transaction_Amount, Tip, Tax, CustomerID, RestaurantID FROM [ORDER] WHERE [Status] = 'Completed';

SELECT OrderItemID, Quantity, UnitPrice, OrderID, MenuItemID FROM ORDERITEM;

SELECT * FROM dbo.fn_GetLowStockIngredients(1);