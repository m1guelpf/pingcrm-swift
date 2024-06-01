import { route } from 'ziggy-js'
import { Page } from '@/Types/app'
import { User } from '@/Types/models'
import { Head } from '@inertiajs/react'
import Layout from '@/Components/Layout'
import { FormEvent, ReactNode } from 'react'
import TextInput from '@/Components/Form/TextInput'
import FileInput from '@/Components/Form/FileInput'
import SelectInput from '@/Components/Form/SelectInput'
import { Link, useForm, router } from '@inertiajs/react'
import DeleteButton from '@/Components/Button/DeleteButton'
import LoadingButton from '@/Components/Button/LoadingButton'
import TrashedMessage from '@/Components/Messages/TrashedMessage'

type EditedUser = Omit<User, 'id' | 'photo' | 'account' | 'deletedAt' | 'createdAt'> & {
	password: string
	photo: File | null
}

type Props = {
	user: User & { password: string }
}

const EditUserPage: Page<Props> = ({ user }) => {
	//@TODO: Make sure file uploads work
	const { data, setData, errors, put, processing } = useForm<EditedUser>({
		photo: null,
		owner: user.owner,
		email: user.email || '',
		password: user.password || '',
		lastName: user.lastName || '',
		firstName: user.firstName || '',
	})

	const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
		e.preventDefault()

		put(route('users.update', user.id))
	}

	const destroy = () => {
		if (!confirm('Are you sure you want to delete this user?')) return

		router.delete(route('users.destroy', user.id))
	}

	const restore = () => {
		if (!confirm('Are you sure you want to restore this user?')) return

		router.put(route('users.restore', user.id))
	}

	return (
		<div>
			<Head title={`${data.firstName} ${data.lastName}`} />
			<div className="flex justify-start max-w-lg mb-8">
				<h1 className="text-3xl font-bold">
					<Link href={route('users')} className="text-indigo-600 hover:text-indigo-700">
						Users
					</Link>
					<span className="mx-2 font-medium text-indigo-600">/</span>
					{data.firstName} {data.lastName}
				</h1>
				{user.photo && <img className="block w-8 h-8 ml-4 rounded-full" src={user.photo} />}
			</div>
			{user.deletedAt && <TrashedMessage onRestore={restore}>This user has been deleted.</TrashedMessage>}
			<div className="max-w-3xl overflow-hidden bg-white rounded shadow">
				<form onSubmit={handleSubmit}>
					<div className="grid gap-8 p-8 lg:grid-cols-2">
						<TextInput
							name="firstName"
							label="First Name"
							value={data.firstName}
							error={errors.firstName}
							onChange={e => setData('firstName', e.target.value)}
						/>
						<TextInput
							name="lastName"
							label="Last Name"
							value={data.lastName}
							error={errors.lastName}
							onChange={e => setData('lastName', e.target.value)}
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
							error={errors.owner}
							value={data.owner ? 'true' : 'false'}
							onChange={e => setData('owner', e.target.value == 'true')}
							options={[
								{ value: 'true', label: 'Yes' },
								{ value: 'false', label: 'No' },
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
						{!user.deletedAt && <DeleteButton onDelete={destroy}>Delete User</DeleteButton>}
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
