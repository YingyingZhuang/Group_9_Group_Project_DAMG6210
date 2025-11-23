from django.contrib import admin
from .models import Customer, Inventory, Order, Restaurant, Ingredient, Table

@admin.register(Customer)
class CustomerAdmin(admin.ModelAdmin):
    list_display = ['customer_id', 'phone', 'email', 'city', 'state', 'zip_code']
    search_fields = ['phone', 'email']
    list_per_page = 20

@admin.register(Inventory)
class InventoryAdmin(admin.ModelAdmin):
    list_display = ['inventory_id', 'ingredient', 'restaurant', 'current_quantity', 'last_updated']
    list_filter = ['restaurant']
    list_per_page = 20

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['order_id', 'customer', 'status', 'order_date_time', 'transaction_amount']
    list_filter = ['status']
    search_fields = ['order_id']
    list_per_page = 20

# register table
admin.site.register(Restaurant)
admin.site.register(Ingredient)
admin.site.register(Table)