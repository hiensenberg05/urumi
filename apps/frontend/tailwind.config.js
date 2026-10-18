/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        brand: {
          bg: '#080d14',
          sidebar: '#060a10',
          card: '#0d1522',
          surface: '#121c2d',
          border: '#1b283d',
          borderLight: '#24344d',
          text: '#f1f5f9',
          muted: '#94a3b8',
          subtle: '#64748b',
          accent: '#10b981', // emerald
          accentHover: '#059669',
          accentGlow: 'rgba(16, 185, 129, 0.12)',
          danger: '#ef4444',
          dangerBg: 'rgba(239, 68, 68, 0.12)',
          warning: '#f59e0b',
          warningBg: 'rgba(245, 158, 11, 0.12)',
          info: '#06b6d4',
          infoBg: 'rgba(6, 182, 212, 0.12)',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
        mono: ['JetBrains Mono', 'Fira Code', 'monospace'],
      }
    },
  },
  plugins: [],
}
