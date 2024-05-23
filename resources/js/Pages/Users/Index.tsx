import { ReactNode } from 'react'
import { Trash2 } from 'lucide-react'
import { User } from '@/Types/models'
import Table from '@/Components/Table'
import Layout from '@/Components/Layout'
import { PaginatedData } from '@/Types/app'
import { Link, usePage } from '@inertiajs/react'
import Pagination from '@/Components/Pagination'
import SearchFilter from '@/Components/SearchFilter'

const UsersPage = () => {
	const { users } = usePage<{ users: PaginatedData<User> }>().props

	const {
		data,
		meta: { links },
	} = users

	return (
		<div>
			<h1 className="mb-8 text-3xl font-bold">Users</h1>
			<div className="flex items-center justify-between mb-6">
				<SearchFilter />
				<Link className="btn-indigo focus:outline-none" href="/users/create">
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
								{row.photo && (
									<img src={row.photo} alt={row.name} className="w-5 h-5 mr-2 rounded-full" />
								)}
								<>{row.name}</>
								{row.deleted_at && <Trash2 size={16} className="ml-2 text-gray-400" />}
							</>
						),
					},
					{ label: 'Email', name: 'email' },
					{ label: 'Role', name: 'owner', colSpan: 2, renderCell: row => (row.owner ? 'Owner' : 'User') },
				]}
				rows={data}
				getRowDetailsUrl={row => `users/${row.id}/edit`}
			/>
			<Pagination links={links} />
		</div>
	)
}

UsersPage.layout = (page: ReactNode) => <Layout title="Users" children={page} />

export default UsersPage
