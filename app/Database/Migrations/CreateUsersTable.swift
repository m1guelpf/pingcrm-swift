import Fluent

struct CreateUsersTable: AsyncMigration {
	func prepare(on database: Database) async throws {
		try await database.schema("users")
			.id()
			.field("account_id", .uuid)
			.field("first_name", .string, .required)
			.field("last_name", .string, .required)
			.unique(on: "first_name", "last_name")
			.field("email", .string, .required).unique(on: "email")
			.field("password", .string, .required)
			.field("owner", .bool, .required, .sql(.default(false)))
			.field("photo", .string)
			.field("created_at", .datetime, .required)
			.field("updated_at", .datetime, .required)
			.field("deleted_at", .datetime)
			.foreignKey("account_id", references: "accounts", "id", onDelete: .cascade)
			.create()
	}

	func revert(on database: Database) async throws {
		try await database.schema("users").delete()
	}
}
