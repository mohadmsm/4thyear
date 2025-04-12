from django import forms
from django.contrib.auth.models import User
from django.core.validators import RegexValidator
from .models import Product, ProductCategory
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