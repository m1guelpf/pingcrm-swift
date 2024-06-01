import type { User } from './models'
import type { FC, ReactNode, JSX } from 'react'

export type PaginatedData<T> = {
	items: T[]
	metadata: {
		page: number
		per: number
		total: number
	}
}

export type PageProps<T extends Record<string, unknown> = Record<string, unknown>> = T & {
	auth: {
		user: User
	}
	flash: {
		success: string | null
		error: string | null
	}
}

export type Page<T extends Record<string, unknown> = Record<string, unknown>> = FC<PageProps<T>> & {
	layout?: (page: ReactNode) => JSX.Element
}
