import { route } from 'ziggy-js'
import { ReactNode } from 'react'
import { Trash2 } from 'lucide-react'
import Table from '@/Components/Table'
import Layout from '@/Components/Layout'
import { PaginatedData } from '@/Types/app'
import { Organization } from '@/Types/models'
import { Link, usePage } from '@inertiajs/react'
import Pagination from '@/Components/Pagination'
import SearchFilter from '@/Components/SearchFilter'

const OrganizationsPage = () => {
	const { organizations } = usePage<{
		organizations: PaginatedData<Organization>
	}>().props

	const {
		data,
		meta: { links },
	} = organizations

	return (
		<div>
			<h1 className="mb-8 text-3xl font-bold">Organizations</h1>
			<div className="flex items-center justify-between mb-6">
				<SearchFilter />
				<Link className="btn-indigo focus:outline-none" href={route('organizations.create')}>
					<span>Create</span>
					<span className="hidden md:inline"> Organization</span>
				</Link>
			</div>
			<Table
				columns={[
					{
						name: 'name',
						label: 'Name',
						renderCell: row => (
							<>
								{row.name}
								{row.deleted_at && <Trash2 size={16} className="ml-2 text-gray-400" />}
							</>
						),
					},
					{ label: 'City', name: 'city' },
					{ label: 'Phone', name: 'phone', colSpan: 2 },
				]}
				rows={data}
				getRowDetailsUrl={row => route('organizations.edit', row.id)}
			/>
			<Pagination links={links} />
		</div>
	)
}

OrganizationsPage.layout = (page: ReactNode) => <Layout title="Organizations" children={page} />

export default OrganizationsPage
