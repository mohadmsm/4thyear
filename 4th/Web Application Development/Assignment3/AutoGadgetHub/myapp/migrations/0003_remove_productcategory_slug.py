# Generated by Django 5.1.8 on 2025-04-12 11:31

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('myapp', '0002_product_productcategory_order_orderitem_cartitem_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='productcategory',
            name='slug',
        ),
    ]
