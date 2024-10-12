/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/**/*.js',
    './app/**/*.erb',
  ],
  theme: {
    extend: {
      animation: {
        border: 'background ease infinite',
        // Add other custom animations if needed
      },
      keyframes: {
        background: {
          '0%, 100%': { backgroundPosition: '0% 50%' },
          '50%': { backgroundPosition: '100% 50%' },
        },
      },
      // Add any other customizations you have
    },
  },
  plugins: [],
}
