import { route } from 'ziggy-js'
import { Page } from '@/Types/app'
import Table from '@/Components/Table'
import { Head } from '@inertiajs/react'
import Layout from '@/Components/Layout'
import { FormEvent, ReactNode } from 'react'
import { Organization } from '@/Types/models'
import TextInput from '@/Components/Form/TextInput'
import SelectInput from '@/Components/Form/SelectInput'
import { Link, useForm, router } from '@inertiajs/react'
import DeleteButton from '@/Components/Button/DeleteButton'
import LoadingButton from '@/Components/Button/LoadingButton'
import TrashedMessage from '@/Components/Messages/TrashedMessage'

type Props = {
	organization: Organization
}

const EditOrganizationPage: Page<Props> = ({ organization }) => {
	const { data, setData, errors, put, processing } = useForm({
		name: organization.name || '',
		city: organization.city || '',
		email: organization.email || '',
		phone: organization.phone || '',
		region: organization.region || '',
		country: organization.country || '',
		address: organization.address || '',
		postal_code: organization.postal_code || '',
	})

	const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
		e.preventDefault()

		put(route('organizations.update', organization.id))
	}

	const destroy = () => {
		if (!confirm('Are you sure you want to delete this organization?')) return

		router.delete(route('organizations.destroy', organization.id))
	}

	const restore = () => {
		if (!confirm('Are you sure you want to restore this organization?')) return

		router.put(route('organizations.restore', organization.id))
	}

	return (
		<div>
			<Head title={data.name} />
			<h1 className="mb-8 text-3xl font-bold">
				<Link href={route('organizations')} className="text-indigo-600 hover:text-indigo-700">
					Organizations
				</Link>
				<span className="mx-2 font-medium text-indigo-600">/</span>
				{data.name}
			</h1>
			{organization.deleted_at && (
				<TrashedMessage onRestore={restore}>This organization has been deleted.</TrashedMessage>
			)}
			<div className="max-w-3xl overflow-hidden bg-white rounded shadow">
				<form onSubmit={handleSubmit}>
					<div className="grid gap-8 p-8 lg:grid-cols-2">
						<TextInput
							name="name"
							label="Name"
							value={data.name}
							error={errors?.name}
							onChange={e => setData('name', e.target.value)}
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
						{!organization.deleted_at && (
							<DeleteButton onDelete={destroy}>Delete Organization</DeleteButton>
						)}
						<LoadingButton loading={processing} type="submit" className="ml-auto btn-indigo">
							Update Organization
						</LoadingButton>
					</div>
				</form>
			</div>
			<h2 className="mt-12 mb-6 text-2xl font-bold">Contacts</h2>
			<Table
				rows={organization.contacts}
				getRowDetailsUrl={row => route('contacts.edit', row.id)}
				columns={[
					{ label: 'Name', name: 'name' },
					{ label: 'City', name: 'city' },
					{ label: 'Phone', name: 'phone', colSpan: 2 },
				]}
			/>
		</div>
	)
}

EditOrganizationPage.layout = (page: ReactNode) => <Layout children={page} />

export default EditOrganizationPage
