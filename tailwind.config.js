const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  content: [
    "./app/views/**/*.{html,erb}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {
      colors: {
        // 水・ティール系（メインカラー）
        water: {
          50:  "#ecfeff",
          100: "#cffafe",
          200: "#a5f3fc",
          300: "#67e8f9",
          400: "#22d3ee",
          500: "#06b6d4",
          600: "#0891b2",
          700: "#0e7490",
          800: "#155e75",
          900: "#164e63",
          950: "#083344"
        },
        // フォレストグリーン系（サブカラー）
        forest: {
          50:  "#f0fdf4",
          100: "#dcfce7",
          200: "#bbf7d0",
          300: "#86efac",
          400: "#4ade80",
          500: "#22c55e",
          600: "#16a34a",
          700: "#15803d",
          800: "#166534",
          900: "#14532d"
        },
        // 砂・土系
        sand: {
          100: "#fef3c7",
          200: "#fde68a",
          400: "#fbbf24",
          600: "#d97706",
          800: "#92400e",
          900: "#78350f"
        },
        // 石・グレー系（UI要素）
        pebble: {
          50:  "#f8fafc",
          100: "#f1f5f9",
          200: "#e2e8f0",
          300: "#cbd5e1",
          400: "#94a3b8",
          500: "#64748b",
          600: "#475569",
          700: "#334155",
          800: "#1e293b",
          900: "#0f172a"
        }
      },
      fontFamily: {
        sans: [ "Noto Sans JP", ...defaultTheme.fontFamily.sans ]
      },
      keyframes: {
        ripple: {
          "0%, 100%": { transform: "scale(1)", opacity: "0.8" },
          "50%":      { transform: "scale(1.05)", opacity: "1" }
        }
      },
      animation: {
        ripple: "ripple 2s ease-in-out infinite"
      }
    }
  },
  plugins: []
}
