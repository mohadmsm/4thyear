from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('shop/', views.shop, name='shop'),
    path('about/', views.about, name='about'),
    path('contact/', views.contact, name='contact'),
    path('help/', views.help, name='help'),
    path('cart/', views.cart, name='cart'),
    path('signup/', views.signup_view, name='signup'),
    path('signin/', views.signin_view, name='signin'),
    path('signout/', views.signout_view, name='signout'),
    path('terms/', views.terms, name='terms'),
    path('checkout/', views.checkout, name='checkout'),
    path('cart/update/<int:product_id>/', views.update_cart, name='update_cart'),
    path('cart/remove/<int:item_id>/', views.remove_from_cart, name='remove_from_cart'),
    # Staff management
    path('staff/products/', views.manage_products, name='manage_products'),
    path('staff/products/add/', views.add_product, name='add_product'),
    path('staff/products/<int:product_id>/edit/', views.edit_product, name='edit_product'),
    path('staff/products/<int:product_id>/delete/', views.delete_product, name='delete_product'),
    path('staff/categories/', views.manage_categories, name='manage_categories'),
    path('staff/categories/add/', views.add_category, name='add_category'),
    path('staff/category/<int:category_id>/edit/', views.category_edit, name='category_edit'),
    path('staff/category/<int:category_id>/delete/', views.category_delete, name='category_delete'),
    path('order-history/', views.order_history, name='order_history'),
    path('api/orders/', views.order_history_api, name='order_history_api'),
]
