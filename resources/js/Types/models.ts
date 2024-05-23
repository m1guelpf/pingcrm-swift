export type User = {
	id: number
	name: string
	first_name: string
	last_name: string
	email: string
	owner: string
	photo: string
	deleted_at: string
	account: Account
}

export type Account = {
	id: number
	name: string
	users: User[]
	contacts: Contact[]
	organizations: Organization[]
}

export type Contact = {
	id: number
	name: string
	first_name: string
	last_name: string
	email: string
	phone: string
	address: string
	city: string
	region: string
	country: string
	postal_code: string
	deleted_at: string
	organization_id: number
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
