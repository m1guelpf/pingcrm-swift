import clsx from 'clsx'
import { FC, InputHTMLAttributes } from 'react'

type Props = InputHTMLAttributes<HTMLInputElement> & {
	label?: string
	error?: string
}

const TextInput: FC<Props> = ({ label, name, className, error, ...props }) => (
	<div className="space-y-2">
		{label && (
			<label className="block text-gray-800 select-none" htmlFor={name}>
				{label}:
			</label>
		)}
		<input
			id={name}
			{...props}
			name={name}
			className={clsx(
				className,
				error && 'border-red-400 focus:border-red-400 focus:ring-red-400',
				'form-input w-full focus:outline-none focus:ring-1 focus:ring-indigo-400 focus:border-indigo-400 border-gray-300 rounded'
			)}
		/>
		{error && <div className="text-red-500 mt-2 text-sm">{error}</div>}
	</div>
)

export default TextInput
