import { route } from 'ziggy-js'
import Logo from '@/Components/Logo'
import { FC, FormEvent } from 'react'
import { Head } from '@inertiajs/react'
import { useForm } from '@inertiajs/react'
import TextInput from '@/Components/Form/TextInput'
import LoadingButton from '@/Components/Button/LoadingButton'

const LoginPage: FC = () => {
	const { data, setData, errors, post, processing } = useForm({
		remember: true,
		password: 'secret',
		email: 'johndoe@example.com',
	})

	const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
		e.preventDefault()

		post(route('login.store'))
	}

	return (
		<div className="flex items-center justify-center min-h-screen p-6 bg-indigo-900">
			<Head title="Login" />

			<div className="w-full max-w-md">
				<Logo className="block w-full max-w-xs mx-auto text-white fill-current" height={50} />
				<form onSubmit={handleSubmit} className="mt-8 overflow-hidden bg-white rounded-lg shadow-xl">
					<div className="px-10 py-12">
						<h1 className="text-3xl font-bold text-center">Welcome Back!</h1>
						<div className="w-24 mx-auto mt-6 border-b-2" />
						<div className="grid gap-6">
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
							<label className="flex items-center select-none" htmlFor="remember">
								<input
									id="remember"
									name="remember"
									type="checkbox"
									checked={data.remember}
									onChange={e => setData('remember', e.target.checked)}
									className="mr-2 form-checkbox rounded text-indigo-600 focus:ring-indigo-600"
								/>
								<span className="text-sm">Remember Me</span>
							</label>
						</div>
					</div>
					<div className="flex items-center justify-between px-10 py-4 bg-gray-100 border-t border-gray-200">
						<a className="hover:underline" tabIndex={-1} href="#reset-password">
							Forgot password?
						</a>
						<LoadingButton type="submit" loading={processing} className="btn-indigo">
							Login
						</LoadingButton>
					</div>
				</form>
			</div>
		</div>
	)
}

export default LoginPage
