import { route } from 'ziggy-js'
import { ReactNode } from 'react'
import { Trash2 } from 'lucide-react'
import Table from '@/Components/Table'
import { Link } from '@inertiajs/react'
import Layout from '@/Components/Layout'
import { Organization } from '@/Types/models'
import FilterBar from '@/Components/FilterBar'
import Pagination from '@/Components/Pagination'
import { Page, PaginatedData } from '@/Types/app'

type Props = {
	organizations: PaginatedData<Organization>
}

const OrganizationsPage: Page<Props> = ({
	organizations: {
		data,
		meta: { links },
	},
}) => {
	return (
		<div>
			<h1 className="mb-8 text-3xl font-bold">Organizations</h1>
			<div className="flex items-center justify-between mb-6">
				<FilterBar />
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
