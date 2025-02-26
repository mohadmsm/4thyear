document.addEventListener('DOMContentLoaded', function () {
    const menu = document.getElementById('sideMenu');
    const overlay = document.getElementById('menuOverlay');
    const hamburger = document.querySelector('.hamburger');
    const closeBtn = document.querySelector('.close-btn');
    const darkModeToggle = document.getElementById('darkModeToggle');

    // Toggle Menu
    function toggleMenu() {
        menu.classList.toggle('active');
        overlay.style.display = menu.classList.contains('active') ? 'block' : 'none';

        // Animate menu items with stagger effect
        const menuItems = document.querySelectorAll('.menu-content a');
        if (menu.classList.contains('active')) {
            menuItems.forEach((item, index) => {
                setTimeout(() => {
                    item.style.opacity = '1';
                    item.style.transform = 'translateX(0)';
                }, index * 100);
            });
        } else {
            menuItems.forEach(item => {
                item.style.opacity = '0';
                item.style.transform = 'translateX(-20px)';
            });
        }
    }

    // Dark Mode Toggle
    function toggleDarkMode() {
        document.body.classList.toggle("dark-mode");
        let isDark = document.body.classList.contains("dark-mode");
        localStorage.setItem("darkMode", isDark);  // Save user preference

        // Toggle switch UI state
        darkModeToggle.classList.toggle("active", isDark);
    }

    // Apply saved Dark Mode preference
    function loadDarkMode() {
        if (localStorage.getItem("darkMode") === "true") {
            document.body.classList.add("dark-mode");
            darkModeToggle.classList.add("active");
        }
    }

    // Event Listeners
    hamburger.addEventListener('click', toggleMenu);
    closeBtn.addEventListener('click', toggleMenu);
    overlay.addEventListener('click', toggleMenu);

    // Dark Mode Event Listener
    darkModeToggle.addEventListener("click", toggleDarkMode);
    // Load Dark Mode setting on page load
    loadDarkMode();
});
