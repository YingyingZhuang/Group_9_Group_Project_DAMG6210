USE RestaurantManagementSystem;
GO

/* ===================== RESTAURANT ===================== */
INSERT INTO RESTAURANT (Restaurant_name, street, city, [state], zip_code, [status], opening_date, phone_number)
VALUES
('Downtown Diner',      '123 Main St',       'Boston',    'MA', '02110', 'Active',              '2018-05-01', '617-555-0001'),
('Harbor Cafe',         '45 Ocean Ave',      'Boston',    'MA', '02111', 'Active',              '2019-03-15', '617-555-0002'),
('City Pizza',          '77 Center St',      'Cambridge', 'MA', '02139', 'Active',              '2020-08-10', '617-555-0003'),
('Riverside Grill',     '12 River Rd',       'Cambridge', 'MA', '02140', 'Temporarily Closed',  '2021-05-20', '617-555-0004'),
('Uptown Noodles',      '88 High St',        'Somerville','MA', '02143', 'Active',              '2017-09-01', '617-555-0005'),
('Garden Vegan',        '6 Greenway',        'Boston',    'MA', '02116', 'Inactive',            '2016-04-18', '617-555-0006'),
('Sunrise Breakfast',   '9 Morning Ln',      'Boston',    'MA', '02118', 'Active',              '2015-01-01', '617-555-0007'),
('Midtown Sushi',       '23 Elm St',         'Boston',    'MA', '02119', 'Active',              '2019-11-11', '617-555-0008'),
('Campus Bites',        '100 College Ave',   'Boston',    'MA', '02120', 'Active',              '2022-02-02', '617-555-0009'),
('Late Night Bites',    '200 Night St',      'Boston',    'MA', '02121', 'Active',              '2020-10-10', '617-555-0010');
GO
-- RestaurantID 将是 1~10

/* ===================== CUSTOMER ===================== */
INSERT INTO CUSTOMER (Phone, Email, Street, City, [State], Zip)
VALUES
('617-888-0001', 'alice@ex.com', '10 Park Dr',   'Boston',    'MA', 2115),
('617-888-0002', 'bob@ex.com',   '22 Lake St',   'Boston',    'MA', 2116),
('617-888-0003', 'cara@ex.com',  '35 Hill Rd',   'Cambridge', 'MA', 2139),
('617-888-0004', 'dave@ex.com',  '40 Oak St',    'Somerville','MA', 2143),
('617-888-0005', 'emma@ex.com',  '55 Pine St',   'Boston',    'MA', 2118),
('617-888-0006', 'fred@ex.com',  '60 Brook St',  'Boston',    'MA', 2119),
('617-888-0007', 'gina@ex.com',  '70 River St',  'Cambridge', 'MA', 2140),
('617-888-0008', 'henry@ex.com', '81 College Rd','Boston',    'MA', 2120),
('617-888-0009', 'ivy@ex.com',   '90 Night Rd',  'Boston',    'MA', 2121),
('617-888-0010', 'jack@ex.com',  '15 Day St',    'Boston',    'MA', 2122);
GO
-- CustomerID 1~10

/* ===================== MENUITEM ===================== */
INSERT INTO MENUITEM ([Name], Price, Category)
VALUES
('Margherita Pizza',    12.50, 'Pizza'),
('Pepperoni Pizza',     14.00, 'Pizza'),
('Cheeseburger',        11.00, 'Burger'),
('Veggie Burger',       10.50, 'Burger'),
('Caesar Salad',         9.00, 'Salad'),
('Garden Salad',         8.50, 'Salad'),
('Spaghetti Bolognese', 13.00, 'Pasta'),
('Fettuccine Alfredo',  13.50, 'Pasta'),
('Miso Ramen',          15.00, 'Noodles'),
('Sushi Combo',         18.00, 'Sushi');
GO
-- MenuItemID 1~10

/* ===================== INGREDIENT ===================== */
INSERT INTO INGREDIENT ([name], unit, category, reorder_level)
VALUES
('Tomato',         'kg',     'Produce', 10.00),
('Cheese',         'kg',     'Dairy',    5.00),
('Lettuce',        'kg',     'Produce',  3.00),
('Beef Patty',     'kg',     'Meat',     8.00),
('Chicken Breast', 'kg',     'Meat',     7.00),
('Pasta',          'kg',     'Grain',    6.00),
('Seaweed',        'kg',     'Seafood',  2.00),
('Soy Sauce',      'L',      'Condiment',4.00),
('Rice',           'kg',     'Grain',   12.00),
('Egg',            'dozen',  'Dairy',    5.00);
GO
-- ingredient_id 1~10

/* ===================== VENDOR ===================== */
INSERT INTO VENDOR ([name], phone_number, street_address, city, [state], Zip)
VALUES
('Fresh Farms',        '617-700-0001', '50 Market St',      'Boston',    'MA', 2201),
('Ocean Seafood',      '617-700-0002', '12 Harbor Rd',      'Boston',    'MA', 2202),
('Green Valley',       '617-700-0003', '99 Farm Ln',        'Lexington', 'MA', 2420),
('Dairy Best',         '617-700-0004', '15 Milk St',        'Boston',    'MA', 2203),
('Prime Meats Co.',    '617-700-0005', '20 Beef Rd',        'Everett',   'MA', 2149),
('Noodle House Supply','617-700-0006', '5 Ramen Way',       'Boston',    'MA', 2204),
('Asian Market',       '617-700-0007', '88 Asia Ave',       'Boston',    'MA', 2205),
('Sunrise Produce',    '617-700-0008', '30 Morning Farm',   'Waltham',   'MA', 2452),
('Campus Wholesale',   '617-700-0009', '100 College Plz',   'Boston',    'MA', 2206),
('Night Owl Foods',    '617-700-0010', '200 Night Depot',   'Boston',    'MA', 2207);
GO
-- vendor_id 1~10

/* ===================== EMPLOYEES ===================== */
INSERT INTO EMPLOYEES ([Name], HireOfDate)
VALUES
('John Smith',      '2020-01-10 09:00:00'),
('Emily Johnson',   '2019-03-15 10:00:00'),
('Michael Brown',   '2021-06-01 11:00:00'),
('Sarah Davis',     '2018-09-20 09:30:00'),
('David Wilson',    '2017-11-05 08:45:00'),
('Laura Martinez',  '2022-02-14 12:00:00'),
('James Anderson',  '2020-07-07 13:15:00'),
('Olivia Thomas',   '2019-12-01 14:00:00'),
('Daniel Taylor',   '2021-03-22 15:30:00'),
('Sophia Lee',      '2016-05-25 08:00:00');
GO
-- Employee_ID 1~10

/* ===================== TABLE ===================== */
INSERT INTO [TABLE] (Seating_Capacity, [Status], Table_Number, RestaurantID)
VALUES
(2, 'Available', 1, 1),
(4, 'Occupied',  2, 1),
(4, 'Reserved',  3, 1),
(2, 'Available', 1, 2),
(4, 'Occupied',  2, 2),
(6, 'Available', 3, 2),
(2, 'Available', 1, 3),
(4, 'Reserved',  2, 3),
(4, 'Available', 1, 4),
(6, 'Occupied',  2, 4);
GO
-- Table_ID 1~10

/* ===================== ORDER ===================== */
INSERT INTO [ORDER] (OrderDateTime, [Status], PaymentInfo, Transaction_Amount, Tip, Tax, CustomerID, RestaurantID, TableID)
VALUES
('2024-10-01 18:30:00', 'Completed', 'Credit Card', 45.00,  5.00,  3.60,  1, 1, 2),
('2024-10-02 12:15:00', 'Completed', 'Cash',        23.50,  0.00,  1.88,  2, 1, 1),
('2024-10-03 19:00:00', 'Pending',   'Credit Card', 30.00,  0.00,  2.40,  3, 2, 4),
('2024-10-04 20:05:00', 'Completed', 'Credit Card', 60.00,  8.00,  4.80,  4, 2, 5),
('2024-10-05 11:45:00', 'Cancelled', 'Cash',        15.00,  0.00,  1.20,  5, 3, 7),
('2024-10-06 13:20:00', 'Completed', 'Credit Card', 28.00,  3.00,  2.24,  6, 3, 8),
('2024-10-07 21:10:00', 'Completed', 'Online Pay',  55.00,  6.00,  4.40,  7, 4, 9),
('2024-10-08 18:10:00', 'Pending',   'Credit Card', 32.00,  0.00,  2.56,  8, 4, 10),
('2024-10-09 17:30:00', 'Completed', 'Cash',        20.00,  2.00,  1.60,  9, 1, 3),
('2024-10-10 14:00:00', 'Completed', 'Online Pay',  18.50,  1.50,  1.48, 10, 2, 6);
GO
-- OrderID 1~10

/* ===================== ORDERITEM ===================== */
INSERT INTO ORDERITEM (Quantity, UnitPrice, OrderID, MenuItemID)
VALUES
(2, 12.50, 1, 1),
(1, 14.00, 1, 2),
(1, 11.00, 2, 3),
(1,  9.00, 2, 5),
(2, 13.00, 3, 7),
(1, 13.50, 4, 8),
(1, 15.00, 4, 9),
(2, 18.00, 7,10),
(1, 10.50, 6, 4),
(1,  8.50,10, 6);
GO

/* ===================== MENU_INGREDIENT ===================== */
INSERT INTO MENU_INGREDIENT (MenuItemID, ingredient_id, quantity_required)
VALUES
(1, 1, 0.20),  -- Margherita Pizza - Tomato
(1, 2, 0.15),  -- + Cheese
(2, 1, 0.15),  -- Pepperoni Pizza - Tomato
(2, 2, 0.20),  -- + Cheese
(3, 4, 0.25),  -- Cheeseburger - Beef Patty
(3, 2, 0.10),  -- + Cheese
(5, 3, 0.20),  -- Caesar Salad - Lettuce
(7, 6, 0.30),  -- Spaghetti Bolognese - Pasta
(9, 9, 0.20),  -- Miso Ramen - Rice (假设)
(9, 8, 0.05);  -- + Soy Sauce
GO

/* ===================== EXPENSE ===================== */
INSERT INTO EXPENSE (expense_date, amount, RestaurantID)
VALUES
('2024-09-01 10:00:00',  500.00, 1),
('2024-09-05 11:00:00',  750.00, 2),
('2024-09-10 09:30:00',  300.00, 3),
('2024-09-12 15:45:00', 1200.00, 4),
('2024-09-15 13:20:00',  450.00, 5),
('2024-09-18 14:10:00',  650.00, 6),
('2024-09-20 16:00:00',  800.00, 7),
('2024-09-22 17:30:00',  920.00, 8),
('2024-09-25 12:00:00',  400.00, 9),
('2024-09-28 10:15:00',  550.00,10);
GO
-- expense_id 1~10

/* ===================== MAINTENANCE ===================== */
INSERT INTO MAINTENANCE (provider_name, expense_id)
VALUES
('HVAC Services Inc.',     1),
('Kitchen Clean Co.',      2),
('Plumbing Pros',          3),
('Electric Fixers',        4),
('Floor Care Ltd.',        5),
('Window Cleaners',        6),
('Grease Trap Services',   7),
('Fire Safety Check',      8),
('Pest Control',           9),
('Equipment Repair Co.',  10);
GO

/* ===================== PAYROLL ===================== */
INSERT INTO PAYROLL (pay_start_period, pay_end_period, expense_id, employee_id)
VALUES
('2024-09-01', '2024-09-15',  1, 1),
('2024-09-01', '2024-09-15',  2, 2),
('2024-09-01', '2024-09-15',  3, 3),
('2024-09-01', '2024-09-15',  4, 4),
('2024-09-01', '2024-09-15',  5, 5),
('2024-09-16', '2024-09-30',  6, 6),
('2024-09-16', '2024-09-30',  7, 7),
('2024-09-16', '2024-09-30',  8, 8),
('2024-09-16', '2024-09-30',  9, 9),
('2024-09-16', '2024-09-30', 10,10);
GO

/* ===================== VENDOR_EXPENSE ===================== */
INSERT INTO Vendor_Expense (expense_id, vendor_id, [description])
VALUES
(1,  1, 'Fresh produce order'),
(2,  2, 'Seafood delivery'),
(3,  3, 'Vegetable supply'),
(4,  4, 'Dairy products'),
(5,  5, 'Meat order'),
(6,  6, 'Noodle supply'),
(7,  7, 'Asian ingredients'),
(8,  8, 'Seasonal produce'),
(9,  9, 'Campus bulk order'),
(10,10, 'Late night supplies');
GO

/* ===================== SUPPLIER_DELIVERY ===================== */
INSERT INTO SUPPLIER_DELIVERY (vendorID, RestaurantID, delivery_date, [description])
VALUES
(1, 1, '2024-09-01', 'Weekly produce delivery'),
(2, 2, '2024-09-02', 'Fresh seafood'),
(3, 3, '2024-09-03', 'Mixed vegetables'),
(4, 4, '2024-09-04', 'Dairy shipment'),
(5, 5, '2024-09-05', 'Meat for burgers'),
(6, 6, '2024-09-06', 'Ramen noodles'),
(7, 7, '2024-09-07', 'Asian groceries'),
(8, 8, '2024-09-08', 'Breakfast produce'),
(9, 9, '2024-09-09', 'Campus special order'),
(10,10,'2024-09-10','Late night stock');
GO
-- delivery_id 1~10

/* ===================== DELIVERY_ITEM ===================== */
INSERT INTO DELIVERY_ITEM (delivery_id, ingredient_id, quantity_delivered, unit_price, expiration_date)
VALUES
(1, 1, 50.00,  1.20, '2024-10-15'),
(2, 2, 30.00,  3.50, '2024-11-01'),
(3, 3, 40.00,  1.00, '2024-10-10'),
(4, 2, 20.00,  3.40, '2024-11-05'),
(5, 4, 25.00,  4.20, '2024-10-20'),
(6, 6, 60.00,  2.10, '2025-01-01'),
(7, 8, 15.00,  5.00, '2025-02-01'),
(8, 10,30.00,  2.50, '2024-10-30'),
(9, 9, 45.00,  1.80, '2024-11-20'),
(10,5, 35.00,  3.80, '2024-11-10');
GO

/* ===================== INVENTORY ===================== */
INSERT INTO INVENTORY (ingredient_id, RestaurantID, current_quantity, last_updated)
VALUES
(1, 1, 20.00, '2024-09-15 10:00:00'),
(2, 1, 15.00, '2024-09-15 10:05:00'),
(3, 2, 25.00, '2024-09-15 10:10:00'),
(4, 2, 18.00, '2024-09-15 10:15:00'),
(5, 3, 22.00, '2024-09-15 10:20:00'),
(6, 3, 30.00, '2024-09-15 10:25:00'),
(7, 4, 12.00, '2024-09-15 10:30:00'),
(8, 5, 10.00, '2024-09-15 10:35:00'),
(9, 6, 40.00, '2024-09-15 10:40:00'),
(10,7, 36.00, '2024-09-15 10:45:00');
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