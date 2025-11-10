
Use RestaurantManagementSystem;
GO

-- 1. Insert RESTAURANT data
INSERT INTO RESTAURANT (Restaurant_name, street, city, [state], zip_code, [status], opening_date, phone_number)
VALUES 
('Boston Downtown Diner', '123 Main Street', 'Boston', 'Massachusetts', '02101', 'Active', '2020-01-15', '617-555-1001'),
('Cambridge Bistro', '456 Harvard Avenue', 'Cambridge', 'Massachusetts', '02139', 'Active', '2019-06-20', '617-555-1002'),
('Somerville Cafe', '789 Elm Street', 'Somerville', 'Massachusetts', '02143', 'Active', '2021-03-10', '617-555-1003'),
('Worcester Grill', '321 Park Avenue', 'Worcester', 'Massachusetts', '01608', 'Temporarily Closed', '2018-11-05', '508-555-1004'),
('Quincy Seafood House', '654 Ocean Drive', 'Quincy', 'Massachusetts', '02169', 'Active', '2020-08-22', '617-555-1005'),
('Newton Fine Dining', '987 Commonwealth Road', 'Newton', 'Massachusetts', '02458', 'Active', '2019-02-14', '617-555-1006'),
('Brookline Steakhouse', '147 Beacon Street', 'Brookline', 'Massachusetts', '02446', 'Active', '2021-07-01', '617-555-1007'),
('Framingham Family Restaurant', '258 Worcester Road', 'Framingham', 'Massachusetts', '01701', 'Active', '2020-05-18', '508-555-1008'),
('Lowell Asian Fusion', '369 Market Street', 'Lowell', 'Massachusetts', '01851', 'Active', '2019-09-30', '978-555-1009'),
('Revere Italian Kitchen', '741 Broadway', 'Revere', 'Massachusetts', '02151', 'Inactive', '2017-12-20', '781-555-1010');
GO

-- 2. Insert CUSTOMER data 
INSERT INTO CUSTOMER (Phone, Email, Street, City, [State], zip_code)
VALUES 
('617-555-2001', 'john@email.com', '100 Oak Street', 'Boston', 'MA', '02101'),
('617-555-2002', 'sarah@email.com', '200 Pine Avenue', 'Cambridge', 'MA', '02139'),
('617-555-2003', 'mike@email.com', '300 Maple Road', 'Somerville', 'MA', '02143'),
('508-555-2004', 'emily@email.com', '400 Cedar Lane', 'Worcester', 'MA', '01608'),
('617-555-2005', 'david@email.com', '500 Birch Street', 'Quincy', 'MA', '02169'),
('617-555-2006', 'lisa@email.com', '600 Willow Drive', 'Newton', 'MA', '02458'),
('617-555-2007', 'james@email.com', '700 Cherry Avenue', 'Brookline', 'MA', '02446'),
('508-555-2008', 'anna@email.com', '800 Spruce Road', 'Framingham', 'MA', '01701'),
('978-555-2009', 'robert@email.com', '900 Ash Lane', 'Lowell', 'MA', '01851'),
('781-555-2010', 'maria@email.com', '1000 Elm Street', 'Revere', 'MA', '02151');
GO

-- 3. Insert MENUITEM data (15 rows)
INSERT INTO MENUITEM ([Name], Price, Category)
VALUES 
('Classic Burger', 12.99, 'Main Course'),
('Grilled Chicken Salad', 11.49, 'Salad'),
('Margherita Pizza', 14.99, 'Main Course'),
('Caesar Salad', 9.99, 'Salad'),
('Spaghetti Carbonara', 13.99, 'Pasta'),
('Grilled Salmon', 18.99, 'Seafood'),
('Fish and Chips', 15.49, 'Seafood'),
('Vegetable Stir Fry', 10.99, 'Vegetarian'),
('Chicken Wings', 8.99, 'Appetizer'),
('French Fries', 4.99, 'Side'),
('Onion Rings', 5.99, 'Side'),
('Chocolate Cake', 6.99, 'Dessert'),
('Ice Cream Sundae', 5.49, 'Dessert'),
('Coca Cola', 2.99, 'Beverage'),
('Iced Tea', 2.49, 'Beverage');
GO

-- 4. Insert TABLE data (12 rows - distributed across restaurants)
INSERT INTO [TABLE] (Seating_Capacity, [Status], Table_Number, RestaurantID)
VALUES 
(4, 'Available', 1, 1),
(2, 'Occupied', 2, 1),
(6, 'Reserved', 3, 1),
(4, 'Available', 4, 1),
(4, 'Available', 1, 2),
(2, 'Available', 2, 2),
(8, 'Reserved', 3, 2),
(4, 'Available', 1, 3),
(6, 'Occupied', 2, 3),
(4, 'Available', 1, 5),
(2, 'Available', 2, 5),
(4, 'Available', 3, 5);
GO

-- 5. Insert ORDER data (10 rows)
INSERT INTO [ORDER] (OrderDateTime, [Status], PaymentInfo, Transaction_Amount, Tip, Tax, CustomerID, RestaurantID, TableID)
VALUES 
('2025-11-01 12:30:00', 'Completed', 'Credit Card', 45.50, 9.10, 3.64, 1, 1, 1),
('2025-11-01 13:15:00', 'Completed', 'Cash', 32.75, 6.55, 2.62, 2, 1, 2),
('2025-11-02 18:45:00', 'Completed', 'Credit Card', 67.89, 13.58, 5.43, 3, 2, 5),
('2025-11-02 19:30:00', 'Pending', 'Credit Card', 55.20, 11.04, 4.42, 4, 2, 6),
('2025-11-03 12:00:00', 'Completed', 'Debit Card', 28.47, 5.69, 2.28, 5, 3, 8),
('2025-11-03 13:30:00', 'Cancelled', 'Cash', 0.00, 0.00, 0.00, 6, 3, 9),
('2025-11-04 17:00:00', 'Completed', 'Credit Card', 91.23, 18.25, 7.30, 7, 5, 10),
('2025-11-04 18:15:00', 'Pending', 'Credit Card', 42.60, 8.52, 3.41, 8, 5, 11),
('2025-11-05 12:45:00', 'Completed', 'Cash', 36.88, 7.38, 2.95, 9, 1, 1),
('2025-11-05 19:00:00', 'Completed', 'Debit Card', 78.45, 15.69, 6.28, 10, 2, 5);
GO

-- 6. Insert ORDERITEM data (20 rows)
INSERT INTO ORDERITEM (Quantity, UnitPrice, OrderID, MenuItemID)
VALUES 
(2, 12.99, 1, 1),
(1, 11.49, 1, 2),
(1, 4.99, 1, 10),
(1, 14.99, 2, 3),
(2, 8.99, 2, 9),
(1, 18.99, 3, 6),
(2, 13.99, 3, 5),
(1, 6.99, 3, 12),
(3, 12.99, 4, 1),
(2, 9.99, 4, 4),
(2, 11.49, 5, 2),
(1, 5.49, 5, 13),
(4, 12.99, 7, 1),
(2, 18.99, 7, 6),
(1, 6.99, 7, 12),
(2, 13.99, 8, 5),
(1, 15.49, 8, 7),
(3, 9.99, 9, 4),
(1, 6.99, 9, 12),
(2, 18.99, 10, 6);
GO

-- 7. Insert INGREDIENT data (15 rows)
INSERT INTO INGREDIENT ([name], unit, category, reorder_level)
VALUES 
('Chicken Breast', 'kg', 'Meat', 50.00),
('Ground Beef', 'kg', 'Meat', 40.00),
('Salmon Fillet', 'kg', 'Seafood', 30.00),
('Shrimp', 'kg', 'Seafood', 25.00),
('Romaine Lettuce', 'kg', 'Vegetable', 20.00),
('Tomatoes', 'kg', 'Vegetable', 30.00),
('Onions', 'kg', 'Vegetable', 40.00),
('Potatoes', 'kg', 'Vegetable', 100.00),
('Olive Oil', 'liter', 'Oil', 15.00),
('All Purpose Flour', 'kg', 'Dry Goods', 50.00),
('White Rice', 'kg', 'Dry Goods', 60.00),
('Eggs', 'dozen', 'Dairy', 30.00),
('Cheddar Cheese', 'kg', 'Dairy', 20.00),
('Butter', 'kg', 'Dairy', 25.00),
('Salt', 'kg', NULL, 10.00);
GO

-- 8. Insert MENU_INGREDIENT data (25 rows)
INSERT INTO MENU_INGREDIENT (MenuItemID, ingredient_id, quantity_required)
VALUES 
(1, 2, 0.20),
(1, 7, 0.03),
(1, 13, 0.05),
(2, 1, 0.25),
(2, 5, 0.15),
(2, 6, 0.05),
(3, 10, 0.30),
(3, 13, 0.15),
(3, 6, 0.10),
(4, 5, 0.20),
(4, 13, 0.03),
(5, 10, 0.15),
(5, 12, 0.08),
(5, 13, 0.05),
(6, 3, 0.25),
(6, 14, 0.02),
(7, 3, 0.20),
(7, 8, 0.30),
(8, 5, 0.10),
(8, 6, 0.15),
(8, 7, 0.10),
(8, 9, 0.03),
(9, 1, 0.50),
(10, 8, 0.40),
(11, 7, 0.30);
GO

-- 9. Insert EXPENSE data (12 rows)
INSERT INTO EXPENSE (expense_date, amount, RestaurantID)
VALUES 
('2025-10-01', 5000.00, 1),
('2025-10-05', 3500.00, 2),
('2025-10-10', 4200.00, 3),
('2025-10-15', 2800.00, 5),
('2025-10-20', 6500.00, 1),
('2025-10-25', 1500.00, 2),
('2025-10-28', 3200.00, 3),
('2025-11-01', 4500.00, 1),
('2025-11-03', 2900.00, 2),
('2025-11-05', 3800.00, 5),
('2025-11-07', 5200.00, 1),
('2025-11-08', 2100.00, 3);
GO

-- 10. Insert EMPLOYEES data (10 rows)
INSERT INTO EMPLOYEES ([Name], HireOfDate)
VALUES 
('John Smith', '2020-01-15'),
('Mary Johnson', '2020-03-20'),
('Robert Williams', '2019-06-10'),
('Patricia Brown', '2021-02-05'),
('Michael Davis', '2020-08-12'),
('Jennifer Miller', '2019-11-30'),
('William Wilson', '2021-05-18'),
('Linda Moore', '2020-09-25'),
('David Taylor', '2019-04-14'),
('Barbara Anderson', '2021-07-22');
GO

-- 11. Insert MAINTENANCE data (10 rows)
INSERT INTO MAINTENANCE (provider_name, expense_id)
VALUES 
('ABC Plumbing Services', 1),
('XYZ HVAC Repair', 2),
('Quick Fix Electrical', 3),
('Pro Clean Janitorial', 4),
('Elite Equipment Repair', 5),
('City Waste Management', 7),
('Superior Pest Control', 8),
('Modern Kitchen Solutions', 9),
('Fast Track Appliance Fix', 10),
('Green Cleaning Services', 12);
GO

-- 12. Insert PAYROLL data (10 rows)
INSERT INTO PAYROLL (pay_start_period, pay_end_period, expense_id, employee_id)
VALUES 
('2025-10-01', '2025-10-15', 6, 1),
('2025-10-01', '2025-10-15', 6, 2),
('2025-10-16', '2025-10-31', 11, 3),
('2025-10-16', '2025-10-31', 11, 4),
('2025-10-16', '2025-10-31', 11, 5),
('2025-10-01', '2025-10-15', 6, 6),
('2025-10-16', '2025-10-31', 11, 7),
('2025-10-01', '2025-10-15', 6, 8),
('2025-10-16', '2025-10-31', 11, 9),
('2025-10-01', '2025-10-15', 6, 10);
GO

-- 13. Insert VENDOR data (10 rows)
INSERT INTO VENDOR ([name], phone_number, street_address, city, [state], zip_code)
VALUES 
('Sysco Boston', '617-555-3001', '123 Industrial Park Road', 'Boston', 'Massachusetts', '02101'),
('US Foods Northeast', '617-555-3002', '456 Commerce Drive', 'Cambridge', 'Massachusetts', '02139'),
('Restaurant Depot', '617-555-3003', '789 Warehouse Street', 'Somerville', 'Massachusetts', '02143'),
('Gordon Food Service', '508-555-3004', '321 Distribution Way', 'Worcester', 'Massachusetts', '01608'),
('Performance Foodservice', '781-555-3005', '654 Supply Lane', 'Quincy', 'Massachusetts', '02169'),
('Baldor Specialty Foods', '617-555-3006', '987 Fresh Market Boulevard', 'Boston', 'Massachusetts', '02118'),
('Shamrock Foods', '508-555-3007', '147 Delivery Road', 'Framingham', 'Massachusetts', '01701'),
('Coastal Seafood Suppliers', '617-555-3008', '258 Harbor Drive', 'Boston', 'Massachusetts', '02210'),
('New England Produce', '978-555-3009', '369 Farm Route', 'Lowell', 'Massachusetts', '01851'),
('Boston Meat Poultry', '617-555-3010', '741 Butcher Lane', 'Revere', 'Massachusetts', '02151');
GO

-- 14. Insert additional EXPENSE data for VENDOR_EXPENSE
INSERT INTO EXPENSE (expense_date, amount, RestaurantID)
VALUES 
('2025-10-02', 1200.00, 1),
('2025-10-06', 850.00, 2),
('2025-10-12', 1500.00, 3),
('2025-10-18', 950.00, 5),
('2025-10-22', 1100.00, 1),
('2025-10-26', 780.00, 2),
('2025-10-30', 1350.00, 3),
('2025-11-02', 920.00, 1),
('2025-11-04', 1050.00, 2),
('2025-11-06', 1180.00, 5);
GO

-- 15. Insert VENDOR_EXPENSE data (10 rows)
INSERT INTO VENDOR_EXPENSE (expense_id, vendor_id, [description])
VALUES 
(13, 1, 'Weekly meat and poultry delivery'),
(14, 2, 'Fresh produce shipment'),
(15, 3, 'Dry goods bulk order'),
(16, 4, 'Seafood delivery'),
(17, 5, 'Specialty ingredients'),
(18, 6, 'Organic vegetables'),
(19, 1, 'Monthly supplies restock'),
(20, 8, 'Premium seafood order'),
(21, 9, 'Fresh produce delivery'),
(22, 10, 'Meat and poultry order');
GO

-- 16. Insert SUPPLIER_DELIVERY data (12 rows) -- vendorID
INSERT INTO SUPPLIER_DELIVERY (vendorID, RestaurantID, delivery_date, [description])
VALUES 
(1, 1, '2025-10-01', 'Weekly meat and poultry delivery'),
(2, 1, '2025-10-03', 'Fresh produce shipment'),
(3, 2, '2025-10-05', 'Dry goods and dairy products'),
(1, 2, '2025-10-07', 'Seafood delivery'),
(4, 3, '2025-10-08', 'General supplies'),
(5, 1, '2025-10-10', 'Specialty ingredients'),
(6, 3, '2025-10-12', 'Organic vegetables'),
(2, 2, '2025-10-15', 'Monthly bulk order'),
(3, 1, '2025-10-18', 'Emergency restock'),
(1, 3, '2025-10-20', 'Weekly delivery'),
(4, 2, '2025-10-22', 'Dairy and eggs'),
(5, 3, '2025-10-25', 'Seasonal ingredients');
GO

-- 17. Insert DELIVERY_ITEM data (25 rows)
INSERT INTO DELIVERY_ITEM (delivery_id, ingredient_id, quantity_delivered, unit_price, expiration_date)
VALUES 
(1, 1, 50.00, 8.50, '2025-10-15'),
(1, 2, 40.00, 7.25, '2025-10-12'),
(2, 5, 25.00, 2.50, '2025-10-10'),
(2, 6, 30.00, 3.00, '2025-10-12'),
(2, 7, 35.00, 1.80, '2025-10-20'),
(3, 10, 100.00, 1.20, '2026-03-01'),
(3, 11, 80.00, 1.50, '2026-05-01'),
(3, 12, 20.00, 4.50, '2025-11-01'),
(4, 3, 30.00, 15.00, '2025-10-14'),
(4, 4, 25.00, 12.00, '2025-10-13'),
(5, 8, 120.00, 1.00, '2025-11-15'),
(5, 9, 20.00, 8.50, '2026-02-01'),
(6, 13, 15.00, 9.00, '2025-11-10'),
(6, 14, 10.00, 6.50, '2025-11-08'),
(7, 5, 30.00, 2.75, '2025-10-20'),
(7, 6, 35.00, 3.10, '2025-10-22'),
(8, 1, 60.00, 8.25, '2025-10-30'),
(8, 2, 45.00, 7.50, '2025-10-28'),
(9, 10, 50.00, 1.25, '2026-04-01'),
(9, 11, 40.00, 1.55, '2026-06-01'),
(10, 3, 25.00, 14.50, '2025-11-02'),
(10, 4, 20.00, 11.80, '2025-11-01'),
(11, 12, 25.00, 4.75, '2025-11-08'),
(11, 13, 12.00, 8.80, '2025-11-12'),
(12, 7, 45.00, 1.90, '2025-11-10');
GO

-- 18. Insert INVENTORY data (20 rows)
INSERT INTO INVENTORY (ingredient_id, RestaurantID, current_quantity, last_updated)
VALUES 
(1, 1, 85.00, '2025-10-18'),
(2, 1, 65.00, '2025-10-18'),
(3, 1, 48.00, '2025-10-20'),
(5, 1, 42.00, '2025-10-03'),
(6, 1, 58.00, '2025-10-03'),
(7, 1, 52.00, '2025-10-03'),
(10, 1, 130.00, '2025-10-18'),
(1, 2, 55.00, '2025-10-07'),
(2, 2, 40.00, '2025-10-15'),
(3, 2, 28.00, '2025-10-07'),
(8, 2, 135.00, '2025-10-08'),
(10, 2, 145.00, '2025-10-05'),
(11, 2, 110.00, '2025-10-05'),
(12, 2, 38.00, '2025-10-22'),
(3, 3, 32.00, '2025-10-20'),
(5, 3, 48.00, '2025-10-12'),
(6, 3, 55.00, '2025-10-12'),
(7, 3, 62.00, '2025-10-25'),
(13, 3, 22.00, '2025-10-12'),
(14, 3, 18.00, '2025-10-12');
GO


SELECT * FROM RESTAURANT;
SELECT * FROM CUSTOMER;
SELECT * FROM MENUITEM;
SELECT * FROM [TABLE];
SELECT * FROM [ORDER];
SELECT * FROM ORDERITEM;
SELECT * FROM INGREDIENT;
SELECT * FROM MENU_INGREDIENT;
SELECT * FROM EXPENSE;
SELECT * FROM MAINTENANCE;
SELECT * FROM EMPLOYEES;
SELECT * FROM PAYROLL;
SELECT * FROM VENDOR;
SELECT * FROM Vendor_Expense;
SELECT * FROM SUPPLIER_DELIVERY;
SELECT * FROM DELIVERY_ITEM;
SELECT * FROM INVENTORY;
GO