import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { createInertiaApp } from '@inertiajs/react'
import { resolvePageComponent } from 'vapor-vite-plugin/inertia-helpers'

const appName = import.meta.env.VITE_APP_NAME || 'Vapor'

createInertiaApp({
	progress: { color: '#F87415' },
	title: title => `${title} - ${appName}`,
	resolve: name => resolvePageComponent(`./Pages/${name}.tsx`, import.meta.glob('./Pages/**/*.tsx')),
	setup({ el, App, props }) {
		const root = createRoot(el)

		root.render(
			<StrictMode>
				<App {...props} />
			</StrictMode>
		)
	},
})
