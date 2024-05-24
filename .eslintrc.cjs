module.exports = {
	root: true,
	parser: '@typescript-eslint/parser',
	env: { browser: true, es2020: true },
	plugins: ['react-refresh', 'react-compiler'],
	ignorePatterns: ['.build', 'dist', '.eslintrc.cjs', 'tailwind.config.js'],
	extends: [
		'eslint:recommended',
		'plugin:react/recommended',
		'plugin:react/jsx-runtime',
		'plugin:react-hooks/recommended',
		'plugin:@typescript-eslint/recommended',
	],
	rules: {
		'react/prop-types': 'off',
		'react/no-children-prop': 'off',
		'react-hooks/rules-of-hooks': 'error',
		'react-hooks/exhaustive-deps': 'warn',
		'react-compiler/react-compiler': 'error',
		'@typescript-eslint/no-unused-vars': 'warn',
		'react/no-unknown-property': ['error', { ignore: ['scroll-region'] }],
		'react-refresh/only-export-components': ['warn', { allowConstantExport: true }],
	},
	settings: {
		react: {
			version: '19.0',
		},
	},
}
