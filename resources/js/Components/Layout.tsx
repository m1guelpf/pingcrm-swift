import { Head } from '@inertiajs/react'
import { FC, PropsWithChildren } from 'react'
import MainMenu from '@/Components/Menu/MainMenu'
import TopHeader from '@/Components/Header/TopHeader'
import BottomHeader from '@/Components/Header/BottomHeader'
import FlashMessages from '@/Components/Messages/FlashMessages'

type Props = PropsWithChildren<{
	title?: string
}>

const Layout: FC<Props> = ({ title, children }) => {
	return (
		<>
			<Head title={title} />
			<div className="flex flex-col">
				<div className="flex flex-col h-screen">
					<div className="md:flex">
						<TopHeader />
						<BottomHeader />
					</div>
					<div className="flex flex-grow overflow-hidden">
						<MainMenu className="flex-shrink-0 hidden w-56 p-12 overflow-y-auto bg-indigo-800 md:block" />
						<div className="w-full px-4 py-8 overflow-hidden overflow-y-auto md:p-12" scroll-region="true">
							<FlashMessages />
							{children}
						</div>
					</div>
				</div>
			</div>
		</>
	)
}

export default Layout
