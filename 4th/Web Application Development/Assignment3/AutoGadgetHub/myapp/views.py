from django.shortcuts import render

# Create your views here.
def home(request):
    return render(request, 'myapp/index.html')

def shop(request):
    return render(request, 'myapp/shop.html')

def about(request):
    return render(request, 'myapp/about.html')

def contact(request):
    return render(request, 'myapp/contact.html')

def help(request):
    return render(request, 'myapp/help.html')

def cart(request):
    return render(request, 'myapp/cart.html')

def signin(request):
    return render(request, 'myapp/signin.html')

def signup(request):
    return render(request, 'myapp/signup.html')

def terms(request):
    return render(request, 'myapp/terms.html')

def checkout(request):
    return render(request, 'myapp/checkout.html')