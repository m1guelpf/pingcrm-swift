import { ReactNode } from 'react'
import Layout from '@/Components/Layout'

const ReportsPage = () => {
	return (
		<div>
			<h1 className="mb-8 text-3xl font-bold">Reports</h1>
			<p className="mb-12 leading-normal">Not implemented</p>
		</div>
	)
}

ReportsPage.layout = (page: ReactNode) => <Layout title="Reports" children={page} />

export default ReportsPage
