import { User } from '@/Types/models'
import Layout from '@/Components/Layout'
import { FormEvent, ReactNode } from 'react'
import { Link, useForm } from '@inertiajs/react'
import TextInput from '@/Components/Form/TextInput'
import FileInput from '@/Components/Form/FileInput'
import SelectInput from '@/Components/Form/SelectInput'
import LoadingButton from '@/Components/Button/LoadingButton'

type NewUser = Omit<User, 'id' | 'photo' | 'account' | 'name' | 'deleted_at'> & { photo: File | null; password: string }

const CreateUserPage = () => {
	const { data, setData, errors, post, processing } = useForm<NewUser>({
		email: '',
		owner: '0',
		photo: null,
		password: '',
		last_name: '',
		first_name: '',
	})

	const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
		e.preventDefault()

		post('/users')
	}

	return (
		<div>
			<div>
				<h1 className="mb-8 text-3xl font-bold">
					<Link href="/users" className="text-indigo-600 hover:text-indigo-700">
						Users
					</Link>
					<span className="font-medium text-indigo-600"> /</span> Create
				</h1>
			</div>
			<div className="max-w-3xl overflow-hidden bg-white rounded shadow">
				<form name="createForm" onSubmit={handleSubmit}>
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
						<TextInput
							name="email"
							type="email"
							label="Email"
							value={data.email}
							error={errors.email}
							onChange={e => setData('email', e.target.value)}
						/>
						<TextInput
							name="password"
							type="password"
							label="Password"
							value={data.password}
							error={errors.password}
							onChange={e => setData('password', e.target.value)}
						/>
						<SelectInput
							name="owner"
							label="Owner"
							value={data.owner}
							error={errors.owner}
							onChange={e => setData('owner', e.target.value)}
							options={[
								{ value: '1', label: 'Yes' },
								{ value: '0', label: 'No' },
							]}
						/>
						<FileInput
							name="photo"
							label="Photo"
							accept="image/*"
							value={data.photo}
							error={errors.photo}
							onChange={photo => setData('photo', photo)}
						/>
					</div>
					<div className="flex items-center justify-end px-8 py-4 bg-gray-100 border-t border-gray-200">
						<LoadingButton loading={processing} type="submit" className="btn-indigo">
							Create User
						</LoadingButton>
					</div>
				</form>
			</div>
		</div>
	)
}

CreateUserPage.layout = (page: ReactNode) => <Layout title="Create User" children={page} />

export default CreateUserPage
