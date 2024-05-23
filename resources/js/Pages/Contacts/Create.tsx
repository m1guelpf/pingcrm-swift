import Layout from '@/Components/Layout'
import { Organization } from '@/Types/models'
import TextInput from '@/Components/Form/TextInput'
import SelectInput from '@/Components/Form/SelectInput'
import { Link, usePage, useForm } from '@inertiajs/react'
import LoadingButton from '@/Components/Button/LoadingButton'

const CreateContactPage = () => {
	const { organizations } = usePage<{ organizations: Organization[] }>().props
	const { data, setData, errors, post, processing } = useForm({
		city: '',
		email: '',
		phone: '',
		region: '',
		country: '',
		address: '',
		last_name: '',
		first_name: '',
		postal_code: '',
		organization_id: '',
	})

	function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
		e.preventDefault()
		post('/contacts')
	}

	return (
		<div>
			<h1 className="mb-8 text-3xl font-bold">
				<Link href="/contacts" className="text-indigo-600 hover:text-indigo-700">
					Contacts
				</Link>
				<span className="font-medium text-indigo-600"> /</span> Create
			</h1>
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
							options={organizations?.map(({ id, name }) => ({
								value: String(id),
								label: name,
							}))}
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
							name="phone"
							type="text"
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
					<div className="flex items-center justify-end px-8 py-4 bg-gray-100 border-t border-gray-200">
						<LoadingButton loading={processing} type="submit" className="btn-indigo">
							Create Contact
						</LoadingButton>
					</div>
				</form>
			</div>
		</div>
	)
}

CreateContactPage.layout = (page: React.ReactNode) => <Layout title="Create Contact" children={page} />

export default CreateContactPage
