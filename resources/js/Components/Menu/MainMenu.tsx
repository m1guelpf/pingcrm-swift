import clsx from 'clsx'
import { FC, ReactNode } from 'react'
import { Link, usePage } from '@inertiajs/react'
import { Building, CircleGauge, Printer, Users } from 'lucide-react'

type Props = {
	className?: string
}

const MainMenu: FC<Props> = ({ className }) => {
	return (
		<div className={className}>
			<MenuItem text="Dashboard" href="/dashboard" icon={<CircleGauge size={20} />} />
			<MenuItem text="Organizations" href="/organizations" icon={<Building size={20} />} />
			<MenuItem text="Contacts" href="/contacts" icon={<Users size={20} />} />
			<MenuItem text="Reports" href="/reports" icon={<Printer size={20} />} />
		</div>
	)
}

interface MainMenuItemProps {
	href: string
	text: string
	icon?: ReactNode
}

const MenuItem = ({ icon, href, text }: MainMenuItemProps) => {
	const url = usePage().url
	//@TODO: Make sure this works
	const isActive = url.startsWith(`/${href}`)

	return (
		<div className="mb-4">
			<Link href={href} className="flex items-center group py-3 space-x-3">
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
