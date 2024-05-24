import { route } from 'ziggy-js'
import { ReactNode } from 'react'
import { Trash2 } from 'lucide-react'
import { User } from '@/Types/models'
import Table from '@/Components/Table'
import { Link } from '@inertiajs/react'
import Layout from '@/Components/Layout'
import FilterBar from '@/Components/FilterBar'
import Pagination from '@/Components/Pagination'
import { Page, PaginatedData } from '@/Types/app'

type Props = {
	users: PaginatedData<User>
}

const UsersPage: Page<Props> = ({
	users: {
		data,
		meta: { links },
	},
}) => (
	<div>
		<h1 className="mb-8 text-3xl font-bold">Users</h1>
		<div className="flex items-center justify-between mb-6">
			<FilterBar />
			<Link className="btn-indigo focus:outline-none" href={route('users.create')}>
				<span>Create</span>
				<span className="hidden md:inline"> User</span>
			</Link>
		</div>
		<Table
			columns={[
				{
					label: 'Name',
					name: 'name',

					renderCell: row => (
						<>
							{row.photo && <img src={row.photo} alt={row.name} className="w-5 h-5 mr-2 rounded-full" />}
							<>{row.name}</>
							{row.deleted_at && <Trash2 size={16} className="ml-2 text-gray-400" />}
						</>
					),
				},
				{ label: 'Email', name: 'email' },
				{ label: 'Role', name: 'owner', colSpan: 2, renderCell: row => (row.owner ? 'Owner' : 'User') },
			]}
			rows={data}
			getRowDetailsUrl={row => route('users.edit', row.id)}
		/>
		<Pagination links={links} />
	</div>
)

UsersPage.layout = (page: ReactNode) => <Layout title="Users" children={page} />

export default UsersPage
