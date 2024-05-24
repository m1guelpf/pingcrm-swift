import clsx from 'clsx'
import React, { useState, useRef, InputHTMLAttributes, FC, ButtonHTMLAttributes } from 'react'

type Props = Omit<InputHTMLAttributes<HTMLInputElement>, 'value' | 'onChange'> & {
	label?: string
	error?: string
	value: File | null
	onChange?: (file: File | null) => void
}

const FileInput: FC<Props> = ({ className, name, label, accept, error, onChange, value }) => {
	'use no memo'

	const fileInput = useRef<HTMLInputElement>(null)
	const [file, setFile] = useState<File | null>(value)

	const handleBrowse = () => fileInput?.current?.click()

	const handleRemove = () => {
		setFile(null)
		onChange?.(null)

		if (fileInput.current) fileInput.current.files = null
	}

	function handleChange(e: React.FormEvent<HTMLInputElement>) {
		const file = (e.target as HTMLInputElement | null)?.files?.[0]
		if (!file) return

		setFile(file)
		onChange?.(file)
	}

	return (
		<div className="space-y-2">
			{label && (
				<label className="block text-gray-800 select-none" htmlFor={name}>
					{label}:
				</label>
			)}
			<div
				className={clsx(
					className,
					error && 'border-red-400 focus:border-red-400 focus:ring-red-400',
					'form-input w-full focus:outline-none focus:ring-1 focus:ring-indigo-400 focus:border-indigo-400 border-gray-300 rounded p-0'
				)}
			>
				<input
					id={name}
					type="file"
					ref={fileInput}
					accept={accept}
					className="hidden"
					onChange={handleChange}
				/>
				{!file && (
					<div className="p-2">
						<BrowseButton text="Browse" onClick={handleBrowse} />
					</div>
				)}
				{file && (
					<div className="flex items-center justify-between p-2">
						<div className="flex-1 pr-1">
							{file?.name}
							<span className="ml-1 text-xs text-gray-600">({fileSize(file?.size)})</span>
						</div>
						<BrowseButton text="Remove" onClick={handleRemove} />
					</div>
				)}
			</div>
			{error && <div className="text-red-500 mt-2 text-sm">{error}</div>}
		</div>
	)
}

type BrowseButtonProps = ButtonHTMLAttributes<HTMLButtonElement> & {
	text: string
}

const BrowseButton: FC<BrowseButtonProps> = ({ text, onClick, ...props }) => (
	<button
		{...props}
		type="button"
		onClick={onClick}
		className="px-4 py-1 text-xs font-medium text-white bg-gray-600 rounded-sm focus:outline-none hover:bg-gray-700"
	>
		{text}
	</button>
)

const fileSize = (size: number): string => {
	const i = Math.floor(Math.log(size) / Math.log(1024))

	return Number((size / Math.pow(1024, i)).toFixed(2)) + ' ' + ['B', 'kB', 'MB', 'GB', 'TB'][i]
}

export default FileInput
