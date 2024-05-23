import clsx from 'clsx'
import { ButtonHTMLAttributes, FC } from 'react'

type Props = ButtonHTMLAttributes<HTMLButtonElement> & {
	loading: boolean
}

const LoadingButton: FC<Props> = ({ loading, className, children, ...props }) => (
	<button
		disabled={loading}
		{...props}
		className={clsx(
			className,
			'flex items-center focus:outline-none',
			loading && 'pointer-events-none bg-opacity-75 select-none'
		)}
	>
		{loading && <div className="mr-2 btn-spinner" />}
		{children}
	</button>
)

export default LoadingButton
