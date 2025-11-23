from django.db import models


class Customer(models.Model):
    customer_id = models.AutoField(db_column='CustomerID', primary_key=True)
    phone = models.CharField(db_column='Phone', max_length=20, blank=True, null=True)
    email = models.CharField(db_column='Email', max_length=20, blank=True, null=True)
    street = models.CharField(db_column='Street', max_length=30, blank=True, null=True)
    city = models.CharField(db_column='City', max_length=20, blank=True, null=True)
    state = models.CharField(db_column='State', max_length=20, blank=True, null=True)
    zip_code = models.CharField(db_column='zip_code', max_length=10)

    class Meta:
        managed = False
        db_table = 'CUSTOMER'

    def __str__(self):
        return f"Customer {self.customer_id}"


class Restaurant(models.Model):
    restaurant_id = models.AutoField(db_column='RestaurantID', primary_key=True)
    restaurant_name = models.CharField(db_column='Restaurant_name', max_length=100)
    street = models.CharField(max_length=100)
    city = models.CharField(max_length=20)
    state = models.CharField(max_length=20)
    zip_code = models.CharField(max_length=10)
    status = models.CharField(max_length=20)
    opening_date = models.DateField()
    phone_number = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'RESTAURANT'

    def __str__(self):
        return self.restaurant_name


class Ingredient(models.Model):
    ingredient_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    unit = models.CharField(max_length=20)
    category = models.CharField(max_length=50, blank=True, null=True)
    reorder_level = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'INGREDIENT'

    def __str__(self):
        return self.name


class Inventory(models.Model):
    inventory_id = models.AutoField(primary_key=True)
    ingredient = models.ForeignKey(Ingredient, on_delete=models.DO_NOTHING, db_column='ingredient_id')
    restaurant = models.ForeignKey(Restaurant, on_delete=models.DO_NOTHING, db_column='RestaurantID')
    current_quantity = models.DecimalField(max_digits=10, decimal_places=2)
    last_updated = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'INVENTORY'

    def __str__(self):
        return f"{self.ingredient.name} - {self.current_quantity}"


class Table(models.Model):
    table_id = models.AutoField(db_column='Table_ID', primary_key=True)
    seating_capacity = models.IntegerField(db_column='Seating_Capacity')
    status = models.CharField(db_column='Status', max_length=20)
    table_number = models.IntegerField(db_column='Table_Number')
    restaurant = models.ForeignKey(Restaurant, on_delete=models.DO_NOTHING, db_column='RestaurantID')

    class Meta:
        managed = False
        db_table = 'TABLE'

    def __str__(self):
        return f"Table {self.table_number}"


class Order(models.Model):
    order_id = models.AutoField(db_column='OrderID', primary_key=True)
    order_date_time = models.DateTimeField(db_column='OrderDateTime')
    status = models.CharField(db_column='Status', max_length=20)
    payment_info = models.CharField(db_column='PaymentInfo', max_length=20)
    transaction_amount = models.DecimalField(db_column='Transaction_Amount', max_digits=10, decimal_places=2)
    tip = models.DecimalField(db_column='Tip', max_digits=10, decimal_places=2)
    tax = models.DecimalField(db_column='Tax', max_digits=10, decimal_places=2)
    customer = models.ForeignKey(Customer, on_delete=models.DO_NOTHING, db_column='CustomerID')
    restaurant = models.ForeignKey(Restaurant, on_delete=models.DO_NOTHING, db_column='RestaurantID')
    table = models.ForeignKey(Table, on_delete=models.DO_NOTHING, db_column='TableID')

    class Meta:
        managed = False
        db_table = 'ORDER'

    def __str__(self):
        return f"Order {self.order_id}"