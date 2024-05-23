import { Trash2 } from 'lucide-react'
import { FC, PropsWithChildren } from 'react'

type Props = PropsWithChildren<{
	onRestore: () => void
}>

const TrashedMessage: FC<Props> = ({ onRestore, children }) => (
	<div className="max-w-3xl mb-6 p-4 bg-yellow-400 rounded border border-yellow-500 flex items-center justify-between">
		<div className="flex items-center space-x-2">
			<Trash2 size={20} className="text-yellow-800" />
			<div className="text-yellow-800">{children}</div>
		</div>
		<button
			type="button"
			tabIndex={-1}
			onClick={onRestore}
			className="text-yellow-800 focus:outline-none text-sm hover:underline"
		>
			Restore
		</button>
	</div>
)

export default TrashedMessage
