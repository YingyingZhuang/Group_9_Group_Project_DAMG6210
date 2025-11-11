

IF exists (Select name from sys.databases WHERE name = 'RestaurantManagementSystem')
   Drop database RestaurantManagementSystem
GO


Create database RestaurantManagementSystem
go


Use RestaurantManagementSystem
Go


-- Drop Tables to Ensure Re-Runability
DROP TABLE IF EXISTS PAYROLL;
DROP TABLE IF EXISTS MAINTENANCE;
DROP TABLE IF EXISTS VENDOR_EXPENSE;
DROP TABLE IF EXISTS DELIVERY_ITEM;
DROP TABLE IF EXISTS SUPPLIER_DELIVERY;
DROP TABLE IF EXISTS INVENTORY;
DROP TABLE IF EXISTS ORDERITEM;
DROP TABLE IF EXISTS MENU_INGREDIENT;
DROP TABLE IF EXISTS [ORDER];
DROP TABLE IF EXISTS [TABLE];
DROP TABLE IF EXISTS EXPENSE;
DROP TABLE IF EXISTS EMPLOYEES;
DROP TABLE IF EXISTS VENDOR;
DROP TABLE IF EXISTS INGREDIENT;
DROP TABLE IF EXISTS MENUITEM;
DROP TABLE IF EXISTS RESTAURANT;
DROP TABLE IF EXISTS CUSTOMER;
GO


--CREATE TABLES
CREATE TABLE RESTAURANT (
   RestaurantID INT IDENTITY(1,1) ,
   Restaurant_name VARCHAR(100) NOT NULL,
   street VARCHAR(100) NOT NULL,
   city VARCHAR(20) NOT NULL,
   [state] VARCHAR(20) NOT NULL,
   zip_code VARCHAR(10) NOT NULL,
   [status] VARCHAR(20) NOT NULL DEFAULT 'Active',
   opening_date DATE NOT NULL,
   phone_number VARCHAR(20) NOT NULL,
   CONSTRAINT pk_restaurant PRIMARY KEY (RestaurantID),
  
   CONSTRAINT chk_restaurant_status CHECK (status IN ('Active', 'Inactive', 'Temporarily Closed')),
   
   CONSTRAINT chk_restaurant_opening_date CHECK (opening_date <= GETDATE())
);
-- customer Table
CREATE TABLE CUSTOMER (
   CustomerID INT NOT NULL IDENTITY(1,1),
   Phone VARCHAR(20) ,
   Email VARCHAR(20) ,
   Street VARCHAR(30) ,
   City VARCHAR(20),
   [State] VARCHAR(20),
   zip_code VARCHAR(10) NOT NULL,


   CONSTRAINT pk_customer PRIMARY KEY (CustomerID),
   CONSTRAINT chk_customer_email CHECK (Email LIKE '%@%')
);

--  Menu item table (no foreign key dependencies)
CREATE TABLE MENUITEM (
   MenuItemID INT NOT NULL IDENTITY(1,1),
   [Name] VARCHAR(50) NOT NULL,
   Price DECIMAL(10,2) NOT NULL,
   Category VARCHAR(100) NOT NULL,
   CONSTRAINT pk_menuitem PRIMARY KEY (MenuItemID),

   CONSTRAINT chk_menuitem_price CHECK (Price > 0)
)

-- Table Table
CREATE TABLE [TABLE] (
   Table_ID INT PRIMARY KEY IDENTITY(1,1),
   Seating_Capacity INT NOT NULL,
   [Status] VARCHAR(20) NOT NULL,
   Table_Number INT NOT NULL,
   RestaurantID INT NOT NULL,


   CONSTRAINT TableSeatingCapacity CHECK (Seating_Capacity > 0),
   CONSTRAINT TableStatus CHECK (Status IN ('Available', 'Occupied', 'Reserved')),
   CONSTRAINT CheckTableNumber CHECK (Table_Number > 0),
   FOREIGN KEY (RestaurantID) REFERENCES RESTAURANT(RestaurantID)
);


-- Order Table
CREATE TABLE [ORDER] (
   OrderID INT PRIMARY KEY IDENTITY(1,1),
   OrderDateTime DATETIME NOT NULL,
   [Status] VARCHAR(20) NOT NULL,
   PaymentInfo VARCHAR(20) NOT NULL,
   Transaction_Amount DECIMAL(10,2) NOT NULL,
   Tip DECIMAL(10,2) NOT NULL,
   Tax DECIMAL(10,2) NOT NULL,
   CustomerID INT NOT NULL,
   RestaurantID INT NOT NULL,
   TableID INT NOT NULL,


   FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
   FOREIGN KEY (RestaurantID) REFERENCES RESTAURANT(RestaurantID),
   FOREIGN KEY (TableID) REFERENCES [TABLE](Table_ID),


   CONSTRAINT OrderStatus CHECK (Status IN ('Pending', 'Completed', 'Cancelled')),
   CONSTRAINT OrderTransactionAmount CHECK (Transaction_Amount >=0),
   CONSTRAINT OrderTip CHECK (Tip >=0),
   CONSTRAINT OrderTax CHECK (Tax >=0)
  
);


-- 5. Order item table (depends on ORDER and MENUITEM)
CREATE TABLE ORDERITEM (
   OrderItemID INT NOT NULL IDENTITY(1,1),
   Quantity INT NOT NULL,
   UnitPrice DECIMAL(10,2) DEFAULT 0,
   OrderID INT NOT NULL,
   MenuItemID INT NOT NULL,


   CONSTRAINT pk_orderitem PRIMARY KEY (OrderItemID),
   -- CHECK constraint 10: Quantity must be greater than 0
   CONSTRAINT chk_orderitem_quantity CHECK (Quantity > 0),
   -- CHECK constraint 11: Unit price must be greater than 0
   CONSTRAINT chk_orderitem_unitprice CHECK (UnitPrice > =0),
   -- Foreign key constraints
   CONSTRAINT fk1_orderitem FOREIGN KEY (OrderID) REFERENCES [ORDER](OrderID),
   CONSTRAINT fk2_orderitem FOREIGN KEY (MenuItemID) REFERENCES MENUITEM(MenuItemID)
);


--ingredient no fk, check for the reorder level>0--
Create Table INGREDIENT (
   ingredient_id int IDENTITY(1,1) NOT NULL,
   [name] VARCHAR(100) NOT NULL,
   unit VARCHAR(20) NOT NULL,
   category VARCHAR(50) NULL,--may not have category--
   reorder_level DECIMAL(10, 2) NOT NULL,
  
   CONSTRAINT PK_Ingredient Primary key (ingredient_id),
   CONSTRAINT CHK_Ingredient_Reorder_Level check (reorder_level >= 0)
);


--need menuitem and ingredient for FK,check quantity--
Create Table MENU_INGREDIENT (
   MenuItemID INT NOT NULL,
   ingredient_id INT NOT NULL,
   quantity_required DECIMAL(10, 2) NOT NULL,-- a weight based
  
   CONSTRAINT PK_Menu_Ingredient Primary Key (MenuItemID, ingredient_id),
   CONSTRAINT FK_Menu_Ingredient_Menu_Item Foreign Key (MenuItemID)
       References MENUITEM(MenuItemID),
   CONSTRAINT FK_Menu_Ingredient_Ingredient Foreign Key (ingredient_id)
       References INGREDIENT(ingredient_id),
   CONSTRAINT CHK_Menu_Ingredient_Quantity Check (quantity_required > 0)
);


CREATE TABLE EXPENSE (
   expense_id INT IDENTITY(1,1) PRIMARY KEY,
   expense_date DATETIME NOT NULL,
   amount DECIMAL(10,2) NOT NULL,
   RestaurantID INT NOT NULL,
   FOREIGN KEY (RestaurantID) REFERENCES RESTAURANT(RestaurantID),
);


CREATE TABLE MAINTENANCE (
   service_id INT IDENTITY(1,1) PRIMARY KEY,
   provider_name VARCHAR(50) NOT NULL,
   expense_id INT NOT NULL,
   FOREIGN KEY (expense_id) REFERENCES EXPENSE(expense_id)
);


CREATE TABLE EMPLOYEES (
   Employee_ID INT IDENTITY(1,1) PRIMARY KEY,
   [Name] VARCHAR(50) NOT NULL,
   HireOfDate DATETIME NOT NULL,
);


CREATE TABLE PAYROLL (
   payroll_id INT IDENTITY(1,1) PRIMARY KEY,
   pay_start_period DATE NOT NULL,
   pay_end_period Date NOT NULL,
   expense_id INT NOT NULL,
   employee_id INT NOT NULL,
   FOREIGN KEY (expense_id) REFERENCES EXPENSE(expense_id),
   FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(Employee_ID)
);

--vendor no fk--
Create Table VENDOR (
   vendor_id INT IDENTITY(1,1) NOT NULL,
   [name] VARCHAR(100) NOT NULL,
   phone_number VARCHAR(20) NOT NULL,
   street_address VARCHAR(200) NOT NULL,
   city VARCHAR(50) NOT NULL,
   [state] VARCHAR(20) NOT NULL,
   zip_code VARCHAR(10) NOT NULL,
  
   CONSTRAINT PK_Vendor Primary key (vendor_id),
);

--need expense table--
--vendor expense use fk from vendor and expense--
CREATE TABLE VENDOR_EXPENSE (
   expense_id INT NOT NULL,
   vendor_id INT NOT NULL,
   [description] VARCHAR(500) NULL,
  
   CONSTRAINT PK_Vendor_Expense primary key (expense_id, vendor_id),
   CONSTRAINT FK_Vendor_Expense_Expense foreign key (expense_id)
       References Expense(expense_id),
   CONSTRAINT FK_Vendor_Expense_Vendor foreign key (vendor_id)
       References Vendor(vendor_id)
);


--need restaurant and vendor table for fk--
Create table SUPPLIER_DELIVERY (
   delivery_id INT IDENTITY(1,1) NOT NULL,
   vendorID INT NOT NULL,
   RestaurantID INT NOT NULL,
   delivery_date DATE NOT NULL,
   [description] VARCHAR(500) NULL,
  
   CONSTRAINT PK_Supplier_Delivery primary key (delivery_id),
   CONSTRAINT FK_Supplier_Delivery_Vendor foreign key (vendorID)
       References VENDOR(vendor_id),
   CONSTRAINT FK_Supplier_Delivery_Restaurant foreign key (RestaurantID)
       References RESTAURANT( RestaurantID )
);


--need supplier delivery and ingredient table--
Create Table DELIVERY_ITEM (
   delivery_id INT NOT NULL,
   ingredient_id INT NOT NULL,
   quantity_delivered DECIMAL(10, 2) NOT NULL,
   unit_price DECIMAL(10, 2) NOT NULL,
   expiration_date DATE NOT NULL,
  
   CONSTRAINT PK_Delivery_Item primary key (delivery_id, ingredient_id),


   CONSTRAINT FK_Delivery_Item_Delivery foreign key (delivery_id)
       References Supplier_Delivery(delivery_id),
   CONSTRAINT FK_Delivery_Item_Ingredient foreign key (ingredient_id)
       References Ingredient(ingredient_id),
   CONSTRAINT CHK_Delivery_Item_Quantity Check (quantity_delivered > 0),
   CONSTRAINT CHK_Delivery_Item_Price Check (unit_price >= 0)
);


--inventory--
--need restaurant and ingredient table--
--composite ingredient and restaurant for unique ,check quantity--
Create Table INVENTORY (
   inventory_id INT IDENTITY(1,1) NOT NULL,
   ingredient_id INT NOT NULL,
   RestaurantID INT NOT NULL,
   current_quantity DECIMAL(10, 2) NOT NULL,
   last_updated DATETIME NOT NULL,
  
   CONSTRAINT PK_Inventory Primary key (inventory_id),
   CONSTRAINT FK_Inventory_ingredient Foreign key (ingredient_id)
       References INGREDIENT(ingredient_id),
   CONSTRAINT FK_Inventory_Restaurant Foreign key (RestaurantID)
       References RESTAURANT(RestaurantID),
   CONSTRAINT UQ_Inventory_Ingredient_Restaurant UNIQUE (ingredient_id, RestaurantID),
   CONSTRAINT CHK_Inventory_Quantity Check (current_quantity >= 0)
);





