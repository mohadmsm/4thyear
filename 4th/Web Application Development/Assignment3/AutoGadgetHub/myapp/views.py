from django.shortcuts import render, redirect, HttpResponse
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from django.contrib.admin.views.decorators import staff_member_required
from django.db import transaction
from django.contrib.auth.models import User
from .models import Product, ProductCategory, CartItem, Order, OrderItem, UserProfile
from .forms import UserRegistrationForm, ProductForm, ProductCategoryForm,checkout_form
from django.shortcuts import get_object_or_404  
from django.http import JsonResponse
from django.utils import timezone
from datetime import timedelta
# Create your views here.
def home(request):
    return render(request, 'myapp/index.html')

def shop(request):
    products = Product.objects.all()
    categories = ProductCategory.objects.all()
    context = {
        'products': products,
        'categories': categories
    }
    return render(request, 'myapp/shop.html', context)

def about(request):
    return render(request, 'myapp/about.html')

def contact(request):
    return render(request, 'myapp/contact.html')

def help(request):
    return render(request, 'myapp/help.html')

@login_required
def cart(request):
    cart_items = CartItem.objects.filter(user=request.user)
    cart_total = sum(item.product.price * item.quantity for item in cart_items)
    
    context = {
        'cart_items': cart_items,
        'cart_total': cart_total
    }
    return render(request, 'myapp/cart.html', context)

@login_required
def update_cart(request, product_id):
    product = get_object_or_404(Product, id=product_id)
    is_ajax = request.headers.get('X-Requested-With') == 'XMLHttpRequest'
    response_data = {}
    default_redirect = request.POST.get('redirect_url', 'cart')

    if request.method == 'POST':
        try:
            quantity = int(request.POST.get('quantity', 1))
            
            # Handle stock validation
            if quantity > product.stock:
                raise ValueError(f"Only {product.stock} available in stock")
            if quantity < 0:
                raise ValueError("Quantity cannot be negative")

            # Get or create cart item
            cart_item, created = CartItem.objects.get_or_create(
                user=request.user,
                product=product,
                defaults={'quantity': quantity}
            )

            # Update or delete existing item
            if not created:
                if quantity > 0:
                    cart_item.quantity = quantity
                    cart_item.save()
                else:
                    cart_item.delete()
                    quantity = 0

            # Prepare response data
            cart_items = CartItem.objects.filter(user=request.user)
            cart_total = sum(item.get_total() for item in cart_items)
            cart_count = cart_items.count()

            response_data = {
                'success': True,
                'message': 'Cart updated successfully',
                'quantity': quantity,
                'item_total': float(product.price * quantity),
                'item_price': float(product.price),
                'cart_total': float(cart_total),
                'cart_count': cart_count
            }

            # Add success message for non-AJAX requests
            if not is_ajax:
                messages.success(request, response_data['message'])

        except Exception as e:
            response_data = {'success': False, 'message': str(e)}
            if not is_ajax:
                messages.error(request, str(e))

        # Return appropriate response
        if is_ajax:
            return JsonResponse(response_data)
        return redirect(default_redirect)

    return JsonResponse({'success': False, 'message': 'Invalid request'}, status=400)

@login_required
def remove_from_cart(request, item_id):
    cart_item = get_object_or_404(CartItem, id=item_id, user=request.user)
    cart_item.delete()
    messages.success(request, 'Item removed from cart')
    return redirect('cart')


def terms(request):
    return render(request, 'myapp/terms.html')

# Checkout and orders
@login_required
def checkout(request):
    cart_items = CartItem.objects.filter(user=request.user)
    if not cart_items.exists():
        messages.error(request, 'Your cart is empty')
        return redirect('shop')
    
    cart_total = sum(item.product.price * item.quantity for item in cart_items)
    
    if request.method == 'POST':
        form = checkout_form(request.POST)  # Instantiate the form with POST data
        if form.is_valid():
            try:
                with transaction.atomic():
                    profile = request.user.profile
                    # Update profile with form data from POST
                    profile.address_line1 = request.POST.get('address_line1')
                    profile.address_line2 = request.POST.get('address_line2')
                    profile.phone_number = request.POST.get('phone')
                    profile.save()
                    
                    # Order processing logic here (same as before)
                    order = Order.objects.create(
                        user=request.user,
                        address=profile.address_line1,
                        total=0
                    )
                    
                    total = 0
                    for item in cart_items:
                        product = item.product
                        if product.stock < item.quantity:
                            raise Exception(f'Insufficient stock for {product.name}')
                        
                        product.stock -= item.quantity
                        product.save()
                        
                        OrderItem.objects.create(
                            order=order,
                            product=product,
                            quantity=item.quantity,
                            price=product.price
                        )
                        total += product.price * item.quantity
                    
                    order.total = total
                    order.save()
                    cart_items.delete()
                    messages.success(request, 'Order placed successfully')
                    return redirect('order_history')
            
            except Exception as e:
                messages.error(request, f'Checkout failed: {str(e)}')
        else:
            # Form is invalid, show errors
            messages.error(request, 'Please correct the errors below.')
    else:
        form = checkout_form()  # Empty form for GET requests
    
    return render(request, 'myapp/checkout.html', {
        'cart_items': cart_items,
        'cart_total': cart_total,
        'form': form,  # Pass the form (with errors if any)
    })

# Staff management views
@staff_member_required
def manage_products(request):
    products = Product.objects.all()
    return render(request, 'myapp/staff/products.html', {'products': products})

@staff_member_required
def add_product(request):
    if request.method == 'POST':
        form = ProductForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            messages.success(request, 'Product added successfully')
            return redirect('manage_products')
    else:
        form = ProductForm()
    return render(request, 'myapp/staff/product_form.html', {'form': form})

@staff_member_required
def edit_product(request, product_id):
    product = get_object_or_404(Product, id=product_id)
    if request.method == 'POST':
        form = ProductForm(request.POST, request.FILES, instance=product)
        if form.is_valid():
            form.save()
            messages.success(request, 'Product updated successfully')
            return redirect('manage_products')
    else:
        form = ProductForm(instance=product)
    return render(request, 'myapp/staff/product_form.html', {'form': form})

@staff_member_required
def delete_product(request, product_id):
    product = get_object_or_404(Product, id=product_id)
    product.delete()
    messages.success(request, 'Product deleted successfully')
    return redirect('manage_products')

@staff_member_required
def manage_categories(request):
    categories = ProductCategory.objects.all()
    if request.method == 'POST':
        form = ProductCategoryForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, 'Category added successfully')
            return redirect('manage_categories')
    else:
        form = ProductCategoryForm()
    return render(request, 'myapp/staff/categories.html', {
        'categories': categories,
        'form': form
    })

@staff_member_required
def add_category(request):
    if request.method == 'POST':
        form = ProductCategoryForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, 'Category added successfully!')
            return redirect('manage_categories')
    else:
        form = ProductCategoryForm()
    return render(request, 'myapp/staff/category_form.html', {'form': form, 'category': None})

@staff_member_required
def category_edit(request, category_id):
    category = get_object_or_404(ProductCategory, id=category_id)
    if request.method == 'POST':
        form = ProductCategoryForm(request.POST, instance=category)
        if form.is_valid():
            form.save()
            messages.success(request, 'Category updated successfully')
            return redirect('manage_categories')
    else:
        form = ProductCategoryForm(instance=category)
    return render(request, 'myapp/staff/category_form.html', {'form': form, 'category': category})

@staff_member_required
def category_delete(request, category_id):
    if request.method == 'POST':
        category = get_object_or_404(ProductCategory, id=category_id)
        try:
            # Prevent deletion of categories with associated products
            if category.product_set.exists():
                messages.error(request, 'Cannot delete category with associated products')
            else:
                category.delete()
                messages.success(request, 'Category deleted successfully')
        except Exception as e:
            messages.error(request, f'Error deleting category: {str(e)}')
        return redirect('manage_categories')
    return HttpResponse("Invalid request method", status=405)


# Authentication views
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

@login_required
def order_history(request):
    orders = Order.objects.filter(user=request.user).order_by('-created')
    return render(request, 'myapp/order_history.html', {'orders': orders})

@login_required
def order_history_api(request):
    period = request.GET.get('period', 'day')
    now = timezone.now()
    
    if period == 'day':
        start_date = now - timedelta(days=1)
    elif period == 'month':
        start_date = now - timedelta(days=30)
    elif period == 'year':
        start_date = now - timedelta(days=365)
    else:
        start_date = now - timedelta(days=1)

    orders = Order.objects.filter(
        user=request.user,
        created__gte=start_date
    ).prefetch_related('items').order_by('-created')
    
    orders_data = []
    for order in orders:
        order_data = {
            'id': order.id,
            'created': order.created.strftime("%b %d, %Y %H:%M"),
            'total': str(order.total),
            'status': order.status,
            'get_status_display': order.get_status_display(),
            'items': []
        }
        for item in order.items.all():
            order_data['items'].append({
                'product_name': item.product.name,
                'quantity': item.quantity,
                'price': str(item.price) #to avoid serialization issues
            })
        orders_data.append(order_data)
    
    return JsonResponse({'orders': orders_data})