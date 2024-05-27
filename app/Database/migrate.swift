import Fluent

public let migrations: [Migration] = [
	SessionRecord.migration,
	CreateAccountsTable(),
	CreateUsersTable(),
	CreateOrganizationsTable(),
	CreateContactsTable(),
]
