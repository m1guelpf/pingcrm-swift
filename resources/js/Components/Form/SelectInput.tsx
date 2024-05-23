import clsx from 'clsx'
import { FC, SelectHTMLAttributes } from 'react'

type Props = SelectHTMLAttributes<HTMLSelectElement> & {
	label?: string
	error?: string
	options: { value: string; label: string }[]
}

const SelectInput: FC<Props> = ({ name, label, className, error, options = [], ...props }) => {
	return (
		<div className="space-y-2">
			{label && (
				<label className=" block text-gray-800 select-none" htmlFor={name}>
					{label}:
				</label>
			)}
			<select
				id={name}
				{...props}
				name={name}
				className={clsx(
					error && 'border-red-400 focus:border-red-400 focus:ring-red-400',
					'form-select w-full focus:outline-none focus:ring-1 focus:ring-indigo-400 focus:border-indigo-400 border-gray-300 rounded'
				)}
			>
				{options?.map(({ value, label }, index) => (
					<option key={index} value={value}>
						{label}
					</option>
				))}
			</select>
			{error && <div className="text-red-500 mt-2 text-sm">{error}</div>}
		</div>
	)
}

export default SelectInput
