import { User } from '@/Types/models'
import { Head } from '@inertiajs/react'
import Layout from '@/Components/Layout'
import { FormEvent, ReactNode } from 'react'
import TextInput from '@/Components/Form/TextInput'
import FileInput from '@/Components/Form/FileInput'
import SelectInput from '@/Components/Form/SelectInput'
import DeleteButton from '@/Components/Button/DeleteButton'
import LoadingButton from '@/Components/Button/LoadingButton'
import { Link, usePage, useForm, router } from '@inertiajs/react'
import TrashedMessage from '@/Components/Messages/TrashedMessage'

type EditedUser = Omit<User, 'id' | 'photo' | 'account' | 'name' | 'deleted_at'> & {
	photo: File | null
	password: string
}

const EditUserPage = () => {
	const { user } = usePage<{ user: User & { password: string } }>().props

	//@TODO: Make sure file uploads work
	const { data, setData, errors, put, processing } = useForm<EditedUser>({
		photo: null,
		email: user.email || '',
		password: user.password || '',
		last_name: user.last_name || '',
		first_name: user.first_name || '',
		owner: user.owner ? '1' : '0' || '0',
	})

	const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
		e.preventDefault()

		put(`/users/${user.id}`)
	}

	const destroy = () => {
		if (!confirm('Are you sure you want to delete this user?')) return

		router.delete(`/users/${user.id}`)
	}

	const restore = () => {
		if (!confirm('Are you sure you want to restore this user?')) return

		router.put(`/users/${user.id}/restore/`)
	}

	return (
		<div>
			<Head title={`${data.first_name} ${data.last_name}`} />
			<div className="flex justify-start max-w-lg mb-8">
				<h1 className="text-3xl font-bold">
					<Link href="/users" className="text-indigo-600 hover:text-indigo-700">
						Users
					</Link>
					<span className="mx-2 font-medium text-indigo-600">/</span>
					{data.first_name} {data.last_name}
				</h1>
				{user.photo && <img className="block w-8 h-8 ml-4 rounded-full" src={user.photo} />}
			</div>
			{user.deleted_at && <TrashedMessage onRestore={restore}>This user has been deleted.</TrashedMessage>}
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
					<div className="flex items-center px-8 py-4 bg-gray-100 border-t border-gray-200">
						{!user.deleted_at && <DeleteButton onDelete={destroy}>Delete User</DeleteButton>}
						<LoadingButton loading={processing} type="submit" className="ml-auto btn-indigo">
							Update User
						</LoadingButton>
					</div>
				</form>
			</div>
		</div>
	)
}

EditUserPage.layout = (page: ReactNode) => <Layout children={page} />

export default EditUserPage
