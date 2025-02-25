document.addEventListener('DOMContentLoaded', function () {
    const contactForm = document.querySelector('.contact-container form');

    contactForm.addEventListener('submit', function (e) {
        e.preventDefault();
        clearErrors(contactForm);

        const name = contactForm.name.value.trim();
        const email = contactForm.email.value.trim();
        const subject = contactForm.subject.value.trim();
        const message = contactForm.message.value.trim();

        let isValid = true;

        // Validate Name
        if (!name || name.length < 3) {
            showError(contactForm.name, 'Name must be at least 3 characters long.');
            isValid = false;
        }

        // Validate Email
        if (!validateEmail(email)) {
            showError(contactForm.email, 'Please enter a valid email address.');
            isValid = false;
        }

        // Validate Subject
        if (!subject || subject.length < 5) {
            showError(contactForm.subject, 'Subject must be at least 5 characters long.');
            isValid = false;
        }

        // Validate Message
        if (!message || message.length < 20) {
            showError(contactForm.message, 'Message must be at least 20 characters long.');
            isValid = false;
        }

        if (isValid) {
            alert('Message sent successfully!');
            contactForm.reset();
        }
    });

    // Helper Functions
    function validateEmail(email) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    }

    function showError(input, message) {
        const errorSpan = input.nextElementSibling;
        errorSpan.textContent = message;
        input.classList.add('error');
    }

    function clearErrors(form) {
        const errors = form.querySelectorAll('.error-message');
        errors.forEach(error => error.textContent = '');
        const inputs = form.querySelectorAll('input, textarea');
        inputs.forEach(input => input.classList.remove('error'));
    }
});