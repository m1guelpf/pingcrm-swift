import clsx from 'clsx'
import { FC } from 'react'
import { Link } from '@inertiajs/react'

type Props = {
	links: PaginationItem[]
}

const Pagination: FC<Props> = ({ links = [] }) => {
	// If there are only 3 links, it means there are no previous or next pages.
	// So, we don't need to render the pagination.
	if (links.length === 3) return null

	return (
		<div className="flex flex-wrap mt-6 -mb-1">
			{links?.map(link => {
				return link?.url === null ? (
					<PageInactive key={link.label} label={link.label} />
				) : (
					<PaginationItem key={link.label} {...link} />
				)
			})}
		</div>
	)
}

type PaginationItem = {
	label: string
	active: boolean
	url: null | string
}

const PaginationItem: FC<PaginationItem> = ({ active, label, url }) => {
	return (
		<Link
			href={url!}
			className={clsx(
				active && 'bg-white',
				'text-sm mr-1 mb-1 px-4 py-3 hover:bg-white border border-solid border-gray-300 rounded focus:outline-none focus:border-indigo-700 focus:text-indigo-700'
			)}
		>
			{/* `label` comes from the API and will either be `&laquo; Previous` or `Next &raquo;` */}
			<span dangerouslySetInnerHTML={{ __html: label }}></span>
		</Link>
	)
}

const PageInactive: FC<{ label: string }> = ({ label }) => (
	<div
		dangerouslySetInnerHTML={{ __html: label }}
		className="mr-1 mb-1 px-4 py-3 text-sm border rounded border-solid border-gray-300 text-gray"
	/>
)

export default Pagination
