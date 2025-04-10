document.addEventListener('DOMContentLoaded', function () {
    const contactForm = document.getElementById('ContactForm');
    const ContactTableBody = document.getElementById('ContactEntriesBody');
    const ContactTable = document.getElementById('ContactTable');
    const Contact_STORAGE_KEY = 'ContactEntries';
    const showEntriesBtn = document.getElementById('showEntriesBttn')
    // event mouseover q4
    showEntriesBtn.addEventListener('mouseover', function () {
        showEntriesBtn.style.backgroundColor = 'green'; // Change color on hover
        showEntriesBtn.style.color = 'white';
    });

    showEntriesBtn.addEventListener('mouseout', function () {
        showEntriesBtn.style.backgroundColor = ''; // Reset to default
        showEntriesBtn.style.color = '';
    });

    contactForm.addEventListener('submit', function (e) {
        e.preventDefault();
        clearErrors(contactForm);

        //confirm event q4
        if (!confirm('Are you sure your email is correct?')) {
            return; // Stop submission if user cancels
        }
        const formData = {
            name: contactForm.name.value.trim(),
            email: contactForm.email.value.trim(),
            subject: contactForm.subject.value.trim(),
            message: contactForm.message.value.trim(),
        };
        let isValid = true;

        // Validate Name
        if (!formData.name || formData.name.length < 3) {
            showError(contactForm.name, 'Name must be at least 3 characters long.');
            isValid = false;
        }

        // Validate Email
        if (!validateEmail(formData.email)) {
            showError(contactForm.email, 'Please enter a valid email address.');
            isValid = false;
        }

        // Validate Subject
        if (!formData.subject || formData.subject.length < 5) {
            showError(contactForm.subject, 'Subject must be at least 5 characters long.');
            isValid = false;
        }

        // Validate Message
        if (!formData.message || formData.message.length < 20) {
            showError(contactForm.message, 'Message must be at least 20 characters long.');
            isValid = false;
        }

        if (isValid) {
            const entry = {
                formData,
                timestamp: new Date().toISOString()
            };
            const entries = JSON.parse(localStorage.getItem(Contact_STORAGE_KEY)) || [];
            entries.push(entry);
            localStorage.setItem(Contact_STORAGE_KEY, JSON.stringify(entries));

            addTableRow(entry);
            contactForm.reset();
            ContactTable.style.display = 'table'; // Show table after submission
            // alert event q4
            alert('Your message has been sent successfully! We will get back to you as soon as possible');

        }
    });

    // Helper Functions
    // Note this email validation is adapted from 'https://stackoverflow.com/questions/46155/how-can-i-validate-an-email-address-in-javascript'
    const validateEmail = (email) => {
        return email.match(
            /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        );
    };
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
    // Table functions
    function loadContactEntries() {
        ContactTableBody.innerHTML = '';
        const entries = JSON.parse(localStorage.getItem(Contact_STORAGE_KEY)) || [];
        entries.forEach(entry => addTableRow(entry));
    }

    function addTableRow(entry) {
        const row = ContactTableBody.insertRow();
        row.innerHTML = `
            <td>${entry.formData.name}</td>
            <td>${entry.formData.email}</td>
            <td>${entry.formData.subject}</td>
            <td>${entry.formData.message}</td>
            <td>${new Date(entry.timestamp).toLocaleString()}</td>
        `;
    }
    // Table toggle
    showEntriesBtn.addEventListener('click', () => {
        ContactTable.style.display = ContactTable.style.display === 'none' ? 'table' : 'none';
    });
    loadContactEntries();
});