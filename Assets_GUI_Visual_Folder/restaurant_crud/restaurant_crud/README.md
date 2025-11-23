# Restaurant Management System - CRUD GUI

A Django-based graphical user interface for managing restaurant operations, including customer information, inventory tracking, and order management.


## Technology Stack

- **Framework**: Django 5.x
- **Database**: Microsoft SQL Server
- **Database Driver**: mssql-django, pyodbc
- **Programming Language**: Python 3.13
- **Admin Interface**: Django Admin
## Features

## Using the Application
**(part of our database)**
### Customer Management

1. Click on **"Customers"** in the admin panel
2. **View**: See list of all customers with their details
3. **Add**: Click "ADD CUSTOMER" button in top-right
4. **Edit**: Click on any customer ID to modify their information
5. **Delete**: Select customers and choose "Delete selected customers" from dropdown

### Inventory Management

1. Click on **"Inventorys"** in the admin panel
2. **View**: Browse all inventory records
3. **Filter**: Use the right sidebar to filter by restaurant
4. **Add**: Click "ADD INVENTORY" to create new inventory record
5. **Edit**: Click on inventory ID to update quantities
6. **Delete**: Select records and delete from dropdown menu

### Order Management

1. Click on **"Orders"** in the admin panel
2. **View**: See all orders with customer, status, and amounts
3. **Filter**: Use filters for status (Pending/Completed/Cancelled)
4. **Add**: Click "ADD ORDER" to create new order
5. **Edit**: Click order ID to modify order details
6. **Delete**: Select and delete orders as needed

## Database Models

### Customer
- CustomerID (Primary Key)
- Phone, Email
- Street, City, State, Zip Code

### Inventory
- inventory_id (Primary Key)
- ingredient (Foreign Key to INGREDIENT)
- restaurant (Foreign Key to RESTAURANT)
- current_quantity
- last_updated

### Order
- OrderID (Primary Key)
- customer (Foreign Key to CUSTOMER)
- restaurant (Foreign Key to RESTAURANT)
- table (Foreign Key to TABLE)
- OrderDateTime, Status
- PaymentInfo, Transaction_Amount, Tip, Tax

## Prerequisites

Before running this application, ensure you have:

- Python 3.8 or higher installed
- Microsoft SQL Server installed and running
- SQL Server ODBC Driver 17 installed
- The `RestaurantManagementSystem` database created and populated

## Installation Steps

### 1. Clone or Download the Project
folder on your choose
```bash
cd D:\restaurant_crud
```

### 2. Create Virtual Environment (Optional but Recommended)
```bash
python -m venv venv
venv\Scripts\activate  # On Windows
```

### 3. Install Required Packages
```bash
pip install django
pip install mssql-django
pip install pyodbc
```

### 4. Configure Database Connection

Open `restaurant_crud/settings.py` and update the database configuration:
```python
DATABASES = {
    'default': {
        'ENGINE': 'mssql',
        'NAME': 'RestaurantManagementSystem',
        'USER': 'sa',
        'PASSWORD': 'your_password',  # Update with your password
        'HOST': 'localhost',
        'PORT': '',
        'OPTIONS': {
            'driver': 'ODBC Driver 17 for SQL Server',
        },
    },
}
```

### 5. Create Django Admin User
```bash
python manage.py migrate
python manage.py createsuperuser
```

Follow the prompts:
- Username: `admin` (or your choice)
- Email: (press Enter to skip)
- Password: Enter a secure password
- Password (again): Confirm password

## Running the Application

### Start the Development Server
```bash
python manage.py runserver
```

You should see output like:
```
Starting development server at http://127.0.0.1:8000/
```

### Access the Admin Interface

1. Open your web browser
2. Navigate to: `http://127.0.0.1:8000/admin`
3. Login with your superuser credentials
4. You will see the admin dashboard with access to all tables
## Stopping the Server

Press `Ctrl + C` in the terminal where the server is running.

## Project Structure
```
restaurant_crud/
├── restaurant_crud/
│   ├── settings.py          # Project settings and database config
│   ├── urls.py              # Main URL routing
│   └── wsgi.py
├── restaurant/
│   ├── models.py            # Database models (Customer, Inventory, Order)
│   ├── admin.py             # Admin interface configuration
│   ├── views.py             # View functions
│   └── migrations/
├── manage.py                # Django management script
└── README.md                # This file
```
## License
This project is for educational purposes only.