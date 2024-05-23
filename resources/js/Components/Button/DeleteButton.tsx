import { ButtonHTMLAttributes, FC } from 'react'

type Props = ButtonHTMLAttributes<HTMLButtonElement> & {
	onDelete: () => void
}

const DeleteButton: FC<Props> = ({ onDelete, children }) => (
	<button type="button" tabIndex={-1} onClick={onDelete} className="text-red-600 focus:outline-none hover:underline">
		{children}
	</button>
)

export default DeleteButton
