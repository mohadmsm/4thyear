document.addEventListener('DOMContentLoaded', function() {
    // Get the card details section and all payment method radio buttons
    const cardDetailsSection = document.getElementById('card-details');
    const paymentMethodRadios = document.querySelectorAll('input[name="payment_method"]');
    
    // Function to toggle the visibility of the card details section
    function toggleCardDetailsVisibility() {
        const selectedPaymentMethod = document.getElementById('input[name="payment_method"]:checked').value;
        
        // Show card details for debit/credit card payment, hide for others
        if (selectedPaymentMethod === 'debit') {
            cardDetailsSection.style.display = 'block';
        } else {
            cardDetailsSection.style.display = 'block';
        }
    }
    
    // Set initial visibility state based on the default selected payment method
    toggleCardDetailsVisibility();
    
    // Add event listeners to all payment method radio buttons
    paymentMethodRadios.forEach(radio => {
        radio.addEventListener('change', toggleCardDetailsVisibility);
    });
});