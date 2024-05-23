import { ReactNode } from 'react'
import { Trash2 } from 'lucide-react'
import Table from '@/Components/Table'
import { Contact } from '@/Types/models'
import Layout from '@/Components/Layout'
import { PaginatedData } from '@/Types/app'
import { Link, usePage } from '@inertiajs/react'
import Pagination from '@/Components/Pagination'
import SearchFilter from '@/Components/SearchFilter'

const ContactsPage = () => {
	const { contacts } = usePage<{
		contacts: PaginatedData<Contact>
	}>().props

	const {
		data,
		meta: { links },
	} = contacts

	return (
		<div>
			<h1 className="mb-8 text-3xl font-bold">Contacts</h1>
			<div className="flex items-center justify-between mb-6">
				<SearchFilter />
				<Link className="btn-indigo focus:outline-none" href="/contacts/create">
					<span>Create</span>
					<span className="hidden md:inline"> Contact</span>
				</Link>
			</div>
			<Table
				rows={data}
				getRowDetailsUrl={row => `contacts/${row.id}/edit`}
				columns={[
					{
						label: 'Name',
						name: 'name',
						renderCell: row => (
							<>
								{row.name}
								{row.deleted_at && <Trash2 size={16} className="ml-2 text-gray-400" />}
							</>
						),
					},
					{ label: 'Organization', name: 'organization.name' },
					{ label: 'City', name: 'city' },
					{ label: 'Phone', name: 'phone', colSpan: 2 },
				]}
			/>
			<Pagination links={links} />
		</div>
	)
}

ContactsPage.layout = (page: ReactNode) => <Layout title="Contacts" children={page} />

export default ContactsPage
