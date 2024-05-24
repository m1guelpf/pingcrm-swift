import clsx from 'clsx'
import { route } from 'ziggy-js'
import { usePrevious } from 'react-use'
import { ChevronDown } from 'lucide-react'
import { usePage, router } from '@inertiajs/react'
import SelectInput from '@/Components/Form/SelectInput'
import { useState, useEffect, FC, ChangeEvent } from 'react'

type PageProps = {
	filters: { role?: string; search?: string; trashed?: string }
}

const FilterBar: FC = () => {
	const { filters } = usePage<PageProps>().props

	const [opened, setOpened] = useState(false)
	const [values, setValues] = useState({
		role: filters.role || '', // role is used only on users page
		search: filters.search || '',
		trashed: filters.trashed || '',
	})

	const prevValues = usePrevious(values)

	const reset = () => setValues({ role: '', search: '', trashed: '' })

	useEffect(() => {
		if (!prevValues) return

		const query = Object.keys(pickBy(values)).length ? pickBy(values) : { remember: 'forget' }
		router.get(route(route().current() as string), query, { replace: true, preserveState: true })
	}, [values])

	const handleChange = (e: ChangeEvent<HTMLSelectElement | HTMLInputElement>) => {
		const key = e.target.name
		const value = e.target.value

		setValues(values => ({ ...values, [key]: value }))
		if (opened) setOpened(false)
	}

	return (
		<div className="flex items-center w-full max-w-md mr-4">
			<div className="relative flex w-full bg-white rounded shadow">
				<div className={clsx(`absolute top-full`, opened ? '' : 'hidden')}>
					<div onClick={() => setOpened(false)} className="fixed inset-0 z-20 bg-black opacity-25" />
					<div className="relative z-30 w-64 px-4 py-6 mt-2 bg-white rounded shadow-lg space-y-4">
						{filters.hasOwnProperty('role') && (
							<SelectInput
								name="role"
								label="Role"
								value={values.role}
								onChange={handleChange}
								options={[
									{ value: '', label: '' },
									{ value: 'user', label: 'User' },
									{ value: 'owner', label: 'Owner' },
								]}
							/>
						)}
						<SelectInput
							name="trashed"
							label="Trashed"
							value={values.trashed}
							onChange={handleChange}
							options={[
								{ value: '', label: '' },
								{ value: 'with', label: 'With Trashed' },
								{ value: 'only', label: 'Only Trashed' },
							]}
						/>
					</div>
				</div>
				<button
					onClick={() => setOpened(true)}
					className="px-4 border-r rounded-l md:px-6 hover:bg-gray-100 focus:outline-none focus:border-white focus:ring-2 focus:ring-indigo-400 focus:z-10"
				>
					<div className="flex items-center">
						<span className="hidden text-gray-700 md:inline">Filter</span>
						<ChevronDown size={14} strokeWidth={3} className="md:ml-2" />
					</div>
				</button>
				<input
					type="text"
					name="search"
					autoComplete="off"
					placeholder="Search…"
					value={values.search}
					onChange={handleChange}
					className="relative form-input border-0 w-full px-6 py-3 rounded-r focus:outline-none focus:ring-2 focus:ring-indigo-400"
				/>
			</div>
			<button
				type="button"
				onClick={reset}
				className="ml-3 text-sm text-gray-600 hover:text-gray-700 focus:text-indigo-700 focus:outline-none"
			>
				Reset
			</button>
		</div>
	)
}

const pickBy = <T extends Record<string, unknown>>(object: T): T => {
	return Object.entries(object)
		.filter(([k, v]) => v)
		.reduce((acc, [k, v]) => ({ ...acc, [k]: v }), {}) as T
}

export default FilterBar
