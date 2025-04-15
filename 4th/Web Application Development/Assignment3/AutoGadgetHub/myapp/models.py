from django.db import models
from django.contrib.auth.models import User
from django.core.validators import MinValueValidator
from django.utils.text import slugify


# user auth Q4 - this class is to extend the user profile info
class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')  # Link to the builtiin user model
    address_line1 = models.CharField(max_length=255, blank=True)  # First adress line
    address_line2 = models.CharField(max_length=255, blank=True, null=True)  # Secound adress line (opitional)
    phone_number = models.CharField(max_length=20, blank=True)  # User's fone number

    def __str__(self):
        return self.user.username  # Return the user name for display

# Categgory model for the products
class ProductCategory(models.Model):
    name = models.CharField(max_length=100)  # Name of the catigory

    def __str__(self):
        return self.name  # Show the name when the object is printed

# This class store info aboute each product
class Product(models.Model):
    category = models.ForeignKey(ProductCategory, on_delete=models.SET_NULL, null=True, blank=True)  # Link to categgory
    name = models.CharField(max_length=200)  # Product's name
    description = models.TextField()  # Descripshon of the product
    product_code = models.CharField(max_length=50, unique=True)  # Unique code for idenntificashon
    image = models.ImageField(upload_to='product_images/')  # Image uplod field
    price = models.DecimalField(max_digits=10, decimal_places=2)  # Cost of the item
    stock = models.PositiveIntegerField(default=0)  # Amont in stock
    created_at = models.DateTimeField(auto_now_add=True)  # Date and time it was created
    
    def __str__(self):
        return self.name  # Show name of product

# Cart item hold info about items added to user's chart
class CartItem(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)  # Refers to the user who added the item
    product = models.ForeignKey(Product, on_delete=models.CASCADE)  # Product bein added
    quantity = models.PositiveIntegerField(default=1)  # How many peeces

    def get_total(self):
        return self.product.price * self.quantity  # Claculates the totel price
    
    def __str__(self):
        return f'{self.user.username}: {self.quantity} x {self.product.name}'  # Display user and item info

# Holds infomation about a purchase order
class Order(models.Model):
    STATUS_CHOICES = [
        ('P', 'Pending'),  # Still waiting
        ('C', 'Completed'),  # All done
        ('X', 'Cancelled')  # Order was canseled
    ]
    
    user = models.ForeignKey(User, on_delete=models.CASCADE)  # Who made the order
    address = models.CharField(max_length=255)  # Where to delivver
    created = models.DateTimeField(auto_now_add=True)  # When the order was created
    total = models.DecimalField(max_digits=10, decimal_places=2)  # Totel price
    status = models.CharField(max_length=1, choices=STATUS_CHOICES, default='P')  # Current statis of the order

    def __str__(self):
        return f'Order #{self.id} by {self.user.username}'  # Display the order info

# Items that are part of a order
class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')  # The order it belongs to
    product = models.ForeignKey(Product, on_delete=models.PROTECT)  # Which product it is
    quantity = models.PositiveIntegerField()  # How many
    price = models.DecimalField(max_digits=10, decimal_places=2)  # Price per item

    def __str__(self):
        return f"{self.quantity} x {self.product.name}"  # Shows quantity and name
