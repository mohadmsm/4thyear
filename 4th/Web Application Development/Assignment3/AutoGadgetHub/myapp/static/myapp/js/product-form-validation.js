document.addEventListener('DOMContentLoaded', function () {
    const productForm = document.querySelector('form#productForm');
    
    if (productForm) {
        productForm.addEventListener('submit', function (e) {
            // Prevent default form submission until validation passes
            e.preventDefault();
            clearErrors(productForm);
            
            // Get form values
            const formData = {
                name: productForm.querySelector('#id_name').value.trim(),
                product_code: productForm.querySelector('#id_product_code').value.trim(),
                price: productForm.querySelector('#id_price').value.trim(),
                stock: productForm.querySelector('#id_stock').value.trim(),
                description: productForm.querySelector('#id_description').value.trim()
            };
            
            // Validation checks
            let isValid = true;
            
            // Product name validation
            if (!formData.name || formData.name.length < 3) {
                showError(productForm.querySelector('#id_name'), 'Product name must be at least 3 characters long');
                isValid = false;
            }
            
            // Product code validation
            if (!formData.product_code || formData.product_code.length < 2) {
                showError(productForm.querySelector('#id_product_code'), 'Product code is required');
                isValid = false;
            }
            
            // Price validation
            if (!formData.price || isNaN(formData.price) || parseFloat(formData.price) <= 0) {
                showError(productForm.querySelector('#id_price'), 'Price must be a positive number');
                isValid = false;
            }
            
            // Stock validation
            if (formData.stock === '' || isNaN(formData.stock) || parseInt(formData.stock) < 0) {
                showError(productForm.querySelector('#id_stock'), 'Stock must be a non-negative number');
                isValid = false;
            }
            
            // Description validation
            if (!formData.description || formData.description.length < 10) {
                showError(productForm.querySelector('#id_description'), 'Description must be at least 10 characters long');
                isValid = false;
            }
            
            // Submit the form if valid
            if (isValid) {
                productForm.submit();
            }
        });
    }
    
    // Error handling functions
    function showError(input, message) {
        // Create error element if it doesn't exist
        let errorElement = input.parentElement.querySelector('.error-message');
        if (!errorElement) {
            errorElement = document.createElement('div');
            errorElement.className = 'error-message';
            input.parentElement.appendChild(errorElement);
        }
        
        errorElement.textContent = message;
        input.classList.add('error');
    }
    
    function clearErrors(form) {
        const errors = form.querySelectorAll('.error-message');
        errors.forEach(error => error.textContent = '');
        const inputs = form.querySelectorAll('input, textarea, select');
        inputs.forEach(input => input.classList.remove('error'));
    }
});
