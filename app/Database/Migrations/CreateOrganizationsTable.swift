import Fluent

struct CreateOrganizationsTable: AsyncMigration {
	func prepare(on database: Database) async throws {
		try await database.schema("organizations")
			.id()
			.field("account_id", .uuid, .required)
			.field("name", .string, .required)
			.field("email", .string)
			.field("phone", .string)
			.field("address", .string)
			.field("city", .string)
			.field("region", .string)
			.field("country", .string)
			.field("postal_code", .string)
			.field("created_at", .datetime, .required)
			.field("updated_at", .datetime, .required)
			.field("deleted_at", .datetime)
			.foreignKey("account_id", references: "accounts", "id", onDelete: .cascade)
			.create()
	}

	func revert(on database: Database) async throws {
		try await database.schema("organizations").delete()
	}
}
