from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('shop/', views.shop, name='shop'),
    path('about/', views.about, name='about'),
    path('contact/', views.contact, name='contact'),
    path('help/', views.help, name='help'),
    path('cart/', views.cart, name='cart'),
    path('signin/', views.signin, name='signin'),
    path('signup/', views.signup, name='signup'),
    path('terms/', views.terms, name='terms'),
    path('checkout/', views.checkout, name='checkout'),
]
