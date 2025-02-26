document.addEventListener('DOMContentLoaded', function () {
    const signupForm = document.getElementById('signupForm');
    const signupTableBody = document.getElementById('signupEntriesBody');
    const signupTable = document.getElementById('signupTable');
    const SIGNUP_STORAGE_KEY = 'signupEntries';
    const showEntriesBtn = document.getElementById('showEntriesBtn')
    
    showEntriesBtn.addEventListener('mouseover', function () {
        showEntriesBtn.style.backgroundColor = 'green'; // Change color on hover
        showEntriesBtn.style.color = 'white';
    });

    showEntriesBtn.addEventListener('mouseout', function () {
        showEntriesBtn.style.backgroundColor = ''; // Reset to default
        showEntriesBtn.style.color = '';
    });
    // Add validation functions
    // Note this email validation is adapted from 'https://stackoverflow.com/questions/46155/how-can-i-validate-an-email-address-in-javascript'
    const validateEmail = (email) => {
        return email.match(
          /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        );
      };
    function validatePassword(password) {
        return password.length >= 8 && /\d/.test(password);
    }

    function validatePhone(phone) {
        const regex = /^\d{10}$/; // 10-digit validation
        return regex.test(phone);
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

    // Table functions
    function loadSignupEntries() {
        signupTableBody.innerHTML = '';
        const entries = JSON.parse(localStorage.getItem(SIGNUP_STORAGE_KEY)) || [];
        entries.forEach(entry => addTableRow(entry));
    }

    function addTableRow(entry) {
        const row = signupTableBody.insertRow();
        row.innerHTML = `
            <td>${entry.username}</td>
            <td>${entry.email}</td>
            <td>${entry.addressLine1}${entry.addressLine2 ? ', ' + entry.addressLine2 : ''}</td>
            <td>${entry.phone}</td>
            <td>${new Date(entry.timestamp).toLocaleString()}</td>
        `;
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
        
        if (formData.username.length < 3) {
            showError(signupForm.username, 'Username must be at least 3 characters');
            isValid = false;
        }
        
        if (!validateEmail(formData.email)) {
            showError(signupForm.email, 'Invalid email format');
            isValid = false;
        }
        
        if (!validatePassword(formData.password)) {
            showError(signupForm.password, 'Password needs 8+ chars with a number');
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
            showError(signupForm.phone, 'Invalid phone number (10 digits)');
            isValid = false;
        }

        // If valid, store and update
        if (isValid) {
            const entry = {formData,
                timestamp: new Date().toISOString()
            };
            
            const entries = JSON.parse(localStorage.getItem(SIGNUP_STORAGE_KEY)) || [];
            entries.push(entry);
            localStorage.setItem(SIGNUP_STORAGE_KEY, JSON.stringify(entries));
            
            addTableRow(entry);
            signupForm.reset();
            signupTable.style.display = 'table'; // Show table after submission
            alert('Registration successful!');
        }
    });

    // Table toggle
    document.getElementById('showEntriesBtn').addEventListener('click', () => {
        signupTable.style.display = signupTable.style.display === 'none' ? 'table' : 'none';
    });

    // Initial load
    loadSignupEntries();
});