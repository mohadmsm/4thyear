from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.contrib import messages
from .forms import UserRegistrationForm
from .models import UserProfile 

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

@login_required
def cart(request):
    return render(request, 'myapp/cart.html')

def terms(request):
    return render(request, 'myapp/terms.html')

@login_required
def checkout(request):
    return render(request, 'myapp/checkout.html')

def signup_view(request):
    if request.method == 'POST':
        form = UserRegistrationForm(request.POST)
        if form.is_valid():
            # Create user
            user = User.objects.create_user(
                username=form.cleaned_data['username'],
                email=form.cleaned_data['email'],
                password=form.cleaned_data['password']
            )
            
            # Create user profile
            UserProfile.objects.create(
                user=user,
                address_line1=form.cleaned_data['address_line1'],
                address_line2=form.cleaned_data['address_line2'],
                phone_number=form.cleaned_data['phone']
            )
            
            messages.success(request, 'Registration successful! Please log in.')
            return redirect('signin')
        
        # If form is invalid, errors will be displayed in template
    else:
        form = UserRegistrationForm()
    
    return render(request, 'myapp/signup.html', {'form': form})

def signin_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            login(request, user)
            return redirect('home')
        else:
            messages.error(request, 'Invalid username or password')
    
    return render(request, 'myapp/signin.html')


def signout_view(request):
    logout(request)
    messages.success(request, 'You have been logged out.')
    return redirect('home')