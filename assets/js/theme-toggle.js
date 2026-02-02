// Theme Toggle for Catppuccin Light/Dark Mode
(function() {
  const STORAGE_KEY = 'theme';
  const DARK = 'dark';
  const LIGHT = 'light';

  // Get the user's preferred theme
  function getPreferredTheme() {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) {
      return stored;
    }
    // Check system preference
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? DARK : LIGHT;
  }

  // Apply theme to document
  function setTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem(STORAGE_KEY, theme);
    updateToggleButton(theme);
  }

  // Update the toggle button icon
  function updateToggleButton(theme) {
    const button = document.querySelector('.theme-toggle');
    if (button) {
      // Sun for dark mode (click to go light), Moon for light mode (click to go dark)
      button.innerHTML = theme === DARK ? '☀️' : '🌙';
      button.setAttribute('aria-label', theme === DARK ? 'Switch to light mode' : 'Switch to dark mode');
    }
  }

  // Toggle between themes
  function toggleTheme() {
    const current = document.documentElement.getAttribute('data-theme') || getPreferredTheme();
    const next = current === DARK ? LIGHT : DARK;
    setTheme(next);
  }

  // Initialize on DOM ready
  function init() {
    // Apply theme immediately to prevent flash
    const theme = getPreferredTheme();
    setTheme(theme);

    // Set up toggle button
    const button = document.querySelector('.theme-toggle');
    if (button) {
      button.addEventListener('click', toggleTheme);
    }

    // Listen for system preference changes
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
      // Only auto-switch if user hasn't manually set a preference
      if (!localStorage.getItem(STORAGE_KEY)) {
        setTheme(e.matches ? DARK : LIGHT);
      }
    });
  }

  // Run initialization
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Also run immediately to prevent flash of wrong theme
  const theme = getPreferredTheme();
  document.documentElement.setAttribute('data-theme', theme);
})();
