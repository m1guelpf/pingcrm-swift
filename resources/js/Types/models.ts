export type User = {
	id: string
	lastName: string
	firstName: string
	email: string
	owner: boolean
	photo: string | null
	createdAt: number
	deletedAt: number | null
	account: { id: number }
}

export type Account = {
	id: number
	name: string
	users: User[]
	contacts: Contact[]
	organizations: Organization[]
}

export type Contact = {
	id: string
	firstName: string
	lastName: string
	email: string
	phone: string
	city: string
	address: string
	region: string
	country: string
	deletedAt: string
	postal_code: string
	organization: Organization
}

export type Organization = {
	id: number
	name: string
	email: string
	phone: string
	address: string
	city: string
	region: string
	country: string
	postal_code: string
	deleted_at: string
	contacts: Contact[]
}
