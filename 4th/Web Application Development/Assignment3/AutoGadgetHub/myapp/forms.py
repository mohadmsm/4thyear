from django import forms
from django.contrib.auth.models import User
from django.core.validators import RegexValidator
from .models import Product, ProductCategory
from datetime import datetime
# user reg form Q4
class UserRegistrationForm(forms.Form):
    username = forms.CharField(
        max_length=150,
        widget=forms.TextInput(attrs={'placeholder': 'Enter your username'}),
        label='Username',
        help_text='Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.'
    )
    email = forms.EmailField(
        widget=forms.EmailInput(attrs={'placeholder': 'Enter your email'}),
        label='Email Address'
    )
    password = forms.CharField(
        widget=forms.PasswordInput(attrs={'placeholder': 'Enter your password'}),
        label='Password',
        min_length=8
    )
    confirm_password = forms.CharField(
        widget=forms.PasswordInput(attrs={'placeholder': 'Confirm your password'}),
        label='Confirm Password'
    )
    address_line1 = forms.CharField(
        max_length=255,
        widget=forms.TextInput(attrs={'placeholder': 'Type in your Address'}),
        label='Address Line 1'
    )
    address_line2 = forms.CharField(
        max_length=255,
        required=False,
        widget=forms.TextInput(attrs={'placeholder': 'Type in your Address line 2 (optional)'}),
        label='Address Line 2'
    )
    phone = forms.CharField(
        max_length=20,
        widget=forms.TextInput(attrs={'placeholder': 'Enter your phone number'}),
        validators=[
            RegexValidator(
                regex=r'^\+?1?\d{9,15}$',
                message='Phone number must be 9-15 digits with optional + prefix.'
            )
        ],
        label='Phone Number'
    )

    def clean_username(self):
        username = self.cleaned_data['username']
        if User.objects.filter(username=username).exists():
            raise forms.ValidationError('This username is already taken.')
        return username

    def clean_email(self):
        email = self.cleaned_data['email']
        if User.objects.filter(email=email).exists():
            raise forms.ValidationError('This email is already registered.')
        return email

    def clean(self):
        cleaned_data = super().clean()
        password = cleaned_data.get('password')
        confirm_password = cleaned_data.get('confirm_password')

        if password and confirm_password and password != confirm_password:
            self.add_error('confirm_password', "Passwords don't match")

        return cleaned_data
    
 # Product Management Form
class ProductForm(forms.ModelForm):
    class Meta:
        model = Product
        fields = ['category', 'name', 'description', 'product_code', 'image', 'price', 'stock']
        widgets = {
            'description': forms.Textarea(attrs={'rows': 3}),
            'image': forms.ClearableFileInput(),
        }
        labels = {
            'product_code': 'SKU/Product Code'
        }
    def clean_price(self):
        price = self.cleaned_data['price']
        if price <= 0:
            raise forms.ValidationError("Price must be greater than 0.")
        return price

    def clean_stock(self):
        stock = self.cleaned_data['stock']
        if stock < 0:
            raise forms.ValidationError("Stock cannot be negative.")
        return stock


class ProductEditForm(forms.ModelForm):
    class Meta:
        model = Product
        fields = ['category', 'description', 'image', 'price', 'stock']
        widgets = {
            'description': forms.Textarea(attrs={'rows': 3}),
            'image': forms.ClearableFileInput(),
        }

class ProductCategoryForm(forms.ModelForm):
    class Meta:
        model = ProductCategory
        fields = ['name']
        labels = {
            'name': 'Category Name'
        }
        widgets = {
            'name': forms.TextInput(attrs={'placeholder': 'Enter category name'})
        }


class checkout_form(forms.Form):
    credit_card_number = forms.CharField(
        max_length=16,
        min_length=13,
        validators=[
            RegexValidator(
                regex=r'^\d{13,16}$',
                message='Credit card number must be between 13 and 16 digits and contain only numbers.'
            )
        ],
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'Credit Card Number',
            'autocomplete': 'cc-number'
        }),
        label='Credit Card Number'
    )
    
    cvv = forms.CharField(
        max_length=4,
        min_length=3,
        validators=[
            RegexValidator(
                regex=r'^\d{3,4}$',
                message='CVV must be 3 or 4 digits and contain only numbers.'
            )
        ],
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'CVV',
            'autocomplete': 'off'
        }),
        label='Security Code (CVV)'
    )
    
    expiry_month = forms.ChoiceField(
        choices=[(str(i).zfill(2), str(i).zfill(2)) for i in range(1, 13)],
        widget=forms.Select(attrs={
            'class': 'form-control',
            'autocomplete': 'cc-exp-month'
        }),
        label='Expiration Month'
    )
    
    expiry_year = forms.ChoiceField(
        choices=[(str(year), str(year)) for year in range(datetime.now().year, datetime.now().year + 15)],
        widget=forms.Select(attrs={
            'class': 'form-control',
            'autocomplete': 'cc-exp-year'
        }),
        label='Expiration Year'
    )

    def clean_credit_card_number(self):
        card_number = self.cleaned_data.get('credit_card_number')
        # First check if it contains only digits
        if not card_number.isdigit():
            raise forms.ValidationError("Credit card number must contain only digits.")
            
        # Then validate using Luhn algorithm
        if not self.luhn_checksum(card_number):
            raise forms.ValidationError("Invalid credit card number.")
        return card_number
    
    def luhn_checksum(self, card_number):
        """Implementation of the Luhn algorithm to validate credit card numbers"""
        def digits_of(n):
            return [int(d) for d in str(n)]
            
        digits = digits_of(card_number)
        odd_digits = digits[-1::-2]
        even_digits = digits[-2::-2]
        
        checksum = sum(odd_digits)
        
        for d in even_digits:
            checksum += sum(digits_of(d * 2))
            
        return checksum % 10 == 0

    def clean(self):
        cleaned_data = super().clean()
        expiry_month = cleaned_data.get('expiry_month')
        expiry_year = cleaned_data.get('expiry_year')
        
        if expiry_month and expiry_year:
            # Check if card is expired
            current_year = datetime.now().year
            current_month = datetime.now().month
            
            if int(expiry_year) == current_year and int(expiry_month) < current_month:
                raise forms.ValidationError("This credit card has expired.")
        
        return cleaned_data