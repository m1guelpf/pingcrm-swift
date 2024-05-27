import Fluent

struct CreateContactsTable: AsyncMigration {
	func prepare(on database: Database) async throws {
		try await database.schema("contacts")
			.id()
			.field("account_id", .uuid, .required)
			.field("organization_id", .uuid)
			.field("first_name", .string, .required)
			.field("last_name", .string, .required)
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
			.foreignKey("organization_id", references: "organizations", "id", onDelete: .setNull)
			.create()
	}

	func revert(on database: Database) async throws {
		try await database.schema("contacts").delete()
	}
}
