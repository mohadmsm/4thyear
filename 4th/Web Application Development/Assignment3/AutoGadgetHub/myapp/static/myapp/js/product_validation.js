document.addEventListener('DOMContentLoaded', function () {
    const productForm = document.getElementById('productForm');
    
    if (productForm) {
        productForm.addEventListener('submit', function (e) {
            e.preventDefault();
            clearErrors(productForm);
            
            const formData = {
                name: productForm.querySelector('#id_name').value.trim(),
                product_code: productForm.querySelector('#id_product_code').value.trim(),
                price: productForm.querySelector('#id_price').value.trim(),
                stock: productForm.querySelector('#id_stock').value.trim(),
                description: productForm.querySelector('#id_description').value.trim()
            };
            
            let isValid = true;
            
            // Product name validation
            if (!formData.name || formData.name.length < 3) {
                showError(productForm.querySelector('#id_name'), 'Product name must be at least 3 characters long');
                isValid = false;
            }
            
            // Product code validation
            if (!formData.product_code || formData.product_code.length < 1) {
                showError(productForm.querySelector('#id_product_code'), 'Product code is required');
                isValid = false;
            }
            
            // Price validation
            if (!formData.price || isNaN(formData.price) || parseFloat(formData.price) <= 0) {
                showError(productForm.querySelector('#id_price'), 'Price must be a positive number');
                isValid = false;
            }
            
            // Stock validation (allow zero)
            if (formData.stock === '' || isNaN(formData.stock) || parseInt(formData.stock) <= 0) {
                showError(productForm.querySelector('#id_stock'), 'Stock must be a positive number');
                isValid = false;
            }
            
            // Description validation
            if (!formData.description || formData.description.length < 10) {
                showError(productForm.querySelector('#id_description'), 'Description must be at least 10 characters long');
                isValid = false;
            }
            
            if (isValid) {
                productForm.submit();
            }
        });
    }
    
    function showError(input, message) {
        const formGroup = input.closest('.form-group');
        if (!formGroup) return;
        const errorElement = formGroup.querySelector('.error-message');
        errorElement.textContent = message;
        input.classList.add('error');
    }
    
    function clearErrors(form) {
        form.querySelectorAll('.error-message').forEach(el => el.textContent = '');
        form.querySelectorAll('.error').forEach(el => el.classList.remove('error'));
    }
});