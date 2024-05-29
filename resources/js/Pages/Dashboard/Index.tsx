import { ReactNode } from 'react'
import { Page } from '@/Types/app'
import { Link } from '@inertiajs/react'
import Layout from '@/Components/Layout'

const DashboardPage: Page = () => (
	<div>
		<h1 className="mb-8 text-3xl font-bold">Dashboard</h1>
		<p className="mb-12 leading-normal">
			Hey there! Welcome to Ping CRM, a demo app designed to help illustrate how
			<a className="mx-1 text-indigo-600 underline hover:text-orange-500" href="https://inertiajs.com">
				Inertia.js
			</a>
			works with
			<a className="ml-1 text-indigo-600 underline hover:text-orange-500" href="https://reactjs.org/">
				React
			</a>
			.
		</p>
	</div>
)

DashboardPage.layout = (page: ReactNode) => <Layout title="Dashboard" children={page} />

export default DashboardPage
