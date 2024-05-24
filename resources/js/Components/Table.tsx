import { ReactNode } from 'react'
import { Link } from '@inertiajs/react'
import { ChevronRight } from 'lucide-react'

type TableProps<T> = {
	rows: T[]
	getRowDetailsUrl?: (row: T) => string
	columns: {
		name: string
		label: string
		colSpan?: number
		renderCell?: (row: T) => ReactNode
	}[]
}

const Table = <T,>({ columns = [], rows = [], getRowDetailsUrl }: TableProps<T>) => (
	<div className="overflow-x-auto bg-white rounded shadow">
		<table className="w-full whitespace-nowrap">
			<thead>
				<tr className="font-bold text-left">
					{columns?.map(column => (
						<th key={column.label} colSpan={column.colSpan ?? 1} className="px-6 pt-5 pb-4">
							{column.label}
						</th>
					))}
				</tr>
			</thead>
			<tbody>
				{/* Empty state */}
				{rows?.length === 0 && (
					<tr>
						<td className="px-6 py-24 border-t text-center" colSpan={columns.length}>
							No data found.
						</td>
					</tr>
				)}
				{rows?.map((row, index) => {
					return (
						<tr key={index} className="hover:bg-gray-100 focus-within:bg-gray-100">
							{columns.map(column => {
								return (
									<td key={column.name} className="border-t">
										<Link
											tabIndex={-1}
											href={getRowDetailsUrl?.(row) as string}
											className="flex items-center px-6 py-4 focus:text-indigo focus:outline-none"
										>
											{column.renderCell?.(row) ?? (get(row, column.name, 'N/A') as ReactNode)}
										</Link>
									</td>
								)
							})}
							<td className="w-px border-t">
								{getRowDetailsUrl && (
									<Link
										href={getRowDetailsUrl(row)}
										className="flex items-center px-4 focus:outline-none"
									>
										<ChevronRight size={24} className="text-gray-400" />
									</Link>
								)}
							</td>
						</tr>
					)
				})}
			</tbody>
		</table>
	</div>
)

const get = <T, K extends keyof T, D>(obj: T, path: K | string, defaultValue: D): T[K] | D => {
	const value = obj[path as keyof T]
	return value === undefined ? defaultValue : (value as T[K])
}

export default Table
