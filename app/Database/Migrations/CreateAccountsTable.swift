import Fluent

struct CreateAccountsTable: AsyncMigration {
	func prepare(on database: Database) async throws {
		try await database.schema("accounts")
			.id()
			.field("name", .string, .required)
			.field("created_at", .datetime, .required)
			.field("updated_at", .datetime, .required)
			.create()
	}

	func revert(on database: Database) async throws {
		try await database.schema("accounts").delete()
	}
}
