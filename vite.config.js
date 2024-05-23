import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import laravel from 'laravel-vite-plugin'

export default defineConfig({
	plugins: [laravel(['resources/js/app.tsx', 'resources/css/app.css']), react()],
	resolve: {
		alias: {
			'@': '/resources/js',
		},
	},
})
