import clsx from 'clsx'
import { route } from 'ziggy-js'
import { FC, ReactNode } from 'react'
import { Link } from '@inertiajs/react'
import { Building, CircleGauge, Printer, Users } from 'lucide-react'

type Props = {
	className?: string
}

const MainMenu: FC<Props> = ({ className }) => {
	return (
		<div className={className}>
			<MenuItem text="Dashboard" link="dashboard" icon={<CircleGauge size={20} />} />
			<MenuItem text="Organizations" link="organizations" icon={<Building size={20} />} />
			<MenuItem text="Contacts" link="contacts" icon={<Users size={20} />} />
			<MenuItem text="Reports" link="reports" icon={<Printer size={20} />} />
		</div>
	)
}

interface MainMenuItemProps {
	link: string
	text: string
	icon?: ReactNode
}

const MenuItem = ({ icon, link, text }: MainMenuItemProps) => {
	const isActive = route().current(link + '*')

	return (
		<div className="mb-4">
			<Link href={route(link)} className="flex items-center group py-3 space-x-3">
				<div
					className={clsx({
						'text-white fill-current': isActive,
						'text-indigo-400 group-hover:text-white fill-current': !isActive,
					})}
				>
					{icon}
				</div>
				<div
					className={clsx({
						'text-white': isActive,
						'text-indigo-200 group-hover:text-white': !isActive,
					})}
				>
					{text}
				</div>
			</Link>
		</div>
	)
}

export default MainMenu
