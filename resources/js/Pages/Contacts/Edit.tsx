import { route } from 'ziggy-js'
import { Page } from '@/Types/app'
import { Head } from '@inertiajs/react'
import Layout from '@/Components/Layout'
import { FormEvent, ReactNode } from 'react'
import TextInput from '@/Components/Form/TextInput'
import { Contact, Organization } from '@/Types/models'
import SelectInput from '@/Components/Form/SelectInput'
import { Link, useForm, router } from '@inertiajs/react'
import DeleteButton from '@/Components/Button/DeleteButton'
import LoadingButton from '@/Components/Button/LoadingButton'
import TrashedMessage from '@/Components/Messages/TrashedMessage'

type Props = {
	contact: Contact
	organizations: Organization[]
}

const EditContactPage: Page<Props> = ({ contact, organizations }) => {
	const { data, setData, errors, put, processing } = useForm({
		city: contact.city || '',
		email: contact.email || '',
		phone: contact.phone || '',
		region: contact.region || '',
		address: contact.address || '',
		country: contact.country || '',
		last_name: contact.last_name || '',
		first_name: contact.first_name || '',
		postal_code: contact.postal_code || '',
		organization_id: contact.organization_id || '',
	})

	const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
		e.preventDefault()

		put(route('contacts.update', contact.id))
	}

	const destroy = () => {
		if (!confirm('Are you sure you want to delete this contact?')) return

		router.delete(route('contacts.destroy', contact.id))
	}

	function restore() {
		if (!confirm('Are you sure you want to restore this contact?')) return

		router.put(route('contacts.restore', contact.id))
	}

	return (
		<div>
			<Head title={`${data.first_name} ${data.last_name}`} />
			<h1 className="mb-8 text-3xl font-bold">
				<Link href={route('contacts')} className="text-indigo-600 hover:text-indigo-700">
					Contacts
				</Link>
				<span className="mx-2 font-medium text-indigo-600">/</span>
				{data.first_name} {data.last_name}
			</h1>
			{contact.deleted_at && <TrashedMessage onRestore={restore}>This contact has been deleted.</TrashedMessage>}
			<div className="max-w-3xl overflow-hidden bg-white rounded shadow">
				<form onSubmit={handleSubmit}>
					<div className="grid gap-8 p-8 lg:grid-cols-2">
						<TextInput
							name="first_name"
							label="First Name"
							value={data.first_name}
							error={errors.first_name}
							onChange={e => setData('first_name', e.target.value)}
						/>
						<TextInput
							name="last_name"
							label="Last Name"
							value={data.last_name}
							error={errors.last_name}
							onChange={e => setData('last_name', e.target.value)}
						/>
						<SelectInput
							label="Organization"
							name="organization_id"
							value={data.organization_id}
							error={errors.organization_id}
							onChange={e => setData('organization_id', e.target.value)}
							options={[
								{ value: '', label: '' },
								...organizations.map(org => ({
									value: String(org.id),
									label: org.name,
								})),
							]}
						/>
						<TextInput
							name="email"
							type="email"
							label="Email"
							value={data.email}
							error={errors.email}
							onChange={e => setData('email', e.target.value)}
						/>
						<TextInput
							type="text"
							name="phone"
							label="Phone"
							value={data.phone}
							error={errors.phone}
							onChange={e => setData('phone', e.target.value)}
						/>
						<TextInput
							type="text"
							name="address"
							label="Address"
							value={data.address}
							error={errors.address}
							onChange={e => setData('address', e.target.value)}
						/>
						<TextInput
							name="city"
							type="text"
							label="City"
							value={data.city}
							error={errors.city}
							onChange={e => setData('city', e.target.value)}
						/>
						<TextInput
							type="text"
							name="region"
							value={data.region}
							error={errors.region}
							label="Province/State"
							onChange={e => setData('region', e.target.value)}
						/>
						<SelectInput
							name="country"
							label="Country"
							value={data.country}
							error={errors.country}
							onChange={e => setData('country', e.target.value)}
							options={[
								{ value: '', label: '' },
								{ value: 'CA', label: 'Canada' },
								{ value: 'US', label: 'United States' },
							]}
						/>
						<TextInput
							type="text"
							name="postal_code"
							label="Postal Code"
							value={data.postal_code}
							error={errors.postal_code}
							onChange={e => setData('postal_code', e.target.value)}
						/>
					</div>
					<div className="flex items-center px-8 py-4 bg-gray-100 border-t border-gray-200">
						{!contact.deleted_at && <DeleteButton onDelete={destroy}>Delete Contact</DeleteButton>}
						<LoadingButton loading={processing} type="submit" className="ml-auto btn-indigo">
							Update Contact
						</LoadingButton>
					</div>
				</form>
			</div>
		</div>
	)
}

EditContactPage.layout = (page: ReactNode) => <Layout children={page} />

export default EditContactPage
