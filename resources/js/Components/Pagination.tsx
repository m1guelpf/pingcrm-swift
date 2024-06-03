import clsx from 'clsx'
import { FC } from 'react'
import { Link } from '@inertiajs/react'
import { PaginatedData } from '@/Types/app'

type Props = {
	meta: PaginatedData<unknown>['metadata']
}

const Pagination: FC<Props> = ({ meta }) => {
	if (meta.total <= meta.per) return null
	const links = Array.from({ length: Math.ceil(meta.total / meta.per) }, (_, i) => {
		const page = i + 1
		return {
			label: page.toString(),
			active: page === meta.page,
			url: page === meta.page ? null : `?page=${page}`,
		}
	})

	return (
		<div className="flex flex-wrap mt-6 -mb-1">
			{links.map(link => (
				<PaginationItem key={link.label} {...link} />
			))}
		</div>
	)
}

type PaginationItem = {
	label: string
	active: boolean
	url: null | string
}

const PaginationItem: FC<PaginationItem> = ({ active, label, url }) => {
	console.log(active, label, url)
	return (
		<Link
			href={url!}
			className={clsx(
				!active && 'opacity-50 hover:opacity-90',
				'text-sm mr-1 mb-1 px-4 py-3 hover:bg-white border border-solid border-gray-300 rounded focus:outline-none focus:border-indigo-700 focus:text-indigo-700'
			)}
		>
			<span>{label}</span>
		</Link>
	)
}

export default Pagination
