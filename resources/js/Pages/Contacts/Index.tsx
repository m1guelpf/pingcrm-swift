import { route } from 'ziggy-js'
import { ReactNode } from 'react'
import { Trash2 } from 'lucide-react'
import Table from '@/Components/Table'
import { Link } from '@inertiajs/react'
import { Contact } from '@/Types/models'
import Layout from '@/Components/Layout'
import FilterBar from '@/Components/FilterBar'
import Pagination from '@/Components/Pagination'
import { Page, PaginatedData } from '@/Types/app'

type Props = {
	contacts: PaginatedData<Contact>
}

const ContactsPage: Page<Props> = ({ contacts }) => {
	const { items, metadata } = contacts

	return (
		<div>
			<h1 className="mb-8 text-3xl font-bold">Contacts</h1>
			<div className="flex items-center justify-between mb-6">
				<FilterBar />
				<Link className="btn-indigo focus:outline-none" href={route('contacts.create')}>
					<span>Create</span>
					<span className="hidden md:inline"> Contact</span>
				</Link>
			</div>
			<Table
				rows={items}
				getRowDetailsUrl={row => route('contacts.edit', row.id)}
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
			<Pagination meta={metadata} />
		</div>
	)
}

ContactsPage.layout = (page: ReactNode) => <Layout title="Contacts" children={page} />

export default ContactsPage
