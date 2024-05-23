import { ReactNode } from 'react'
import Layout from '@/Components/Layout'
import { Link, useForm } from '@inertiajs/react'
import TextInput from '@/Components/Form/TextInput'
import SelectInput from '@/Components/Form/SelectInput'
import LoadingButton from '@/Components/Button/LoadingButton'

const CreateOrganizationPage = () => {
	const { data, setData, errors, post, processing } = useForm({
		name: '',
		city: '',
		email: '',
		phone: '',
		region: '',
		address: '',
		country: '',
		postal_code: '',
	})

	function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
		e.preventDefault()
		post('/organizations')
	}

	return (
		<div>
			<h1 className="mb-8 text-3xl font-bold">
				<Link href="/organizations" className="text-indigo-600 hover:text-indigo-700">
					Organizations
				</Link>
				<span className="font-medium text-indigo-600"> /</span> Create
			</h1>
			<div className="max-w-3xl overflow-hidden bg-white rounded shadow">
				<form onSubmit={handleSubmit}>
					<div className="grid gap-8 p-8 lg:grid-cols-2">
						<TextInput
							name="name"
							label="Name"
							value={data.name}
							error={errors.name}
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
							label="Country"
							name="country"
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
					<div className="flex items-center justify-end px-8 py-4 bg-gray-100 border-t border-gray-200">
						<LoadingButton loading={processing} type="submit" className="btn-indigo">
							Create Organization
						</LoadingButton>
					</div>
				</form>
			</div>
		</div>
	)
}

CreateOrganizationPage.layout = (page: ReactNode) => <Layout title="Create Organization" children={page} />

export default CreateOrganizationPage
