import { defineConfig } from 'vite'
import vapor from 'vapor-vite-plugin'
import react from '@vitejs/plugin-react'

export default defineConfig({
	plugins: [
		vapor(['resources/js/app.tsx', 'resources/css/app.css']),
		react({ babel: { plugins: ['babel-plugin-react-compiler'] } }),
	],
	resolve: {
		alias: { '@': '/resources/js' },
	},
})
