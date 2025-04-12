document.addEventListener('DOMContentLoaded', function () {
    const signupForm = document.getElementById('signupForm');
    
    // Add validation functions
    // Note this email validation is adapted from 'https://stackoverflow.com/questions/46155/how-can-i-validate-an-email-address-in-javascript'

    const validateEmail = (email) => {
        return email.match(
            /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        );
    };

    function validatePassword(password) {
        // At least 8 characters
        const isLengthValid = password.length >= 8;
        // Contains at least one digit
        const hasNumber = /\d/.test(password);
        // Contains at least one letter (uppercase or lowercase)
        const hasLetter = /[a-zA-Z]/.test(password);
        // Contains at least one special character (@, ., /, etc.)
        const hasSpecialChar = /[@./\\!@#$%^&*(),.?":{}|<>]/.test(password);
        
        return isLengthValid && hasNumber && hasLetter && hasSpecialChar;
    }

    function validatePhone(phone) {
        const regex = /^\d{10}$/;
        return regex.test(phone);
    }

    function validateUsername(username) {
        return username.length >= 3 && 
               /^[a-zA-Z]/.test(username) && // Starts with letter
               /^[a-zA-Z0-9_]+$/.test(username); 
    }

    // Error handling functions
    function showError(input, message) {
        const errorSpan = input.parentElement.querySelector('.error-message');
        errorSpan.textContent = message;
        input.classList.add('error');
    }

    function clearErrors(form) {
        const errors = form.querySelectorAll('.error-message');
        errors.forEach(error => error.textContent = '');
        const inputs = form.querySelectorAll('input');
        inputs.forEach(input => input.classList.remove('error'));
    }

    // Form submission handler
    signupForm.addEventListener('submit', function (e) {
        e.preventDefault();
        clearErrors(signupForm);

        // Get form values
        const formData = {
            username: signupForm.username.value.trim(),
            email: signupForm.email.value.trim(),
            password: signupForm.password.value.trim(),
            confirmPassword: signupForm['confirm-password'].value.trim(),
            addressLine1: signupForm['address-line1'].value.trim(),
            addressLine2: signupForm['address-line2'].value.trim(),
            phone: signupForm.phone.value.trim()
        };

        // Validation checks
        let isValid = true;

        if (!validateUsername(formData.username)) {
            showError(signupForm.username, 'Username must start with a letter and contain only letters, numbers, and underscores (3+ characters)');
            isValid = false;
        }

        if (!validateEmail(formData.email)) {
            showError(signupForm.email, 'Invalid email format');
            isValid = false;
        }

        if (!validatePassword(formData.password)) {
            showError(signupForm.password, 'Password needs 8+ characters with at least one number, letter and spec char ');
            isValid = false;
        }

        if (formData.password !== formData.confirmPassword) {
            showError(signupForm['confirm-password'], 'Passwords do not match');
            isValid = false;
        }

        if (!formData.addressLine1) {
            showError(signupForm['address-line1'], 'Address required');
            isValid = false;
        }

        if (!validatePhone(formData.phone)) {
            showError(signupForm.phone, 'Invalid phone number (10 digits required)');
            isValid = false;
        }

        if (isValid) {
            // Submit the form if valid
            signupForm.submit();
        }
    });
});
