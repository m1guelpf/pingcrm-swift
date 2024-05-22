import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react';

export default defineConfig({
	plugins: [
		laravel({
			refresh: true,
			publicDirectory: 'Public',
			input: ['Resources/Frontend/app.tsx'],
		}),
		react(),
	],
	resolve: {
		alias: {
			'@': '/Resources/Frontend',
		},
	},
});
