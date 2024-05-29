import Vapor
import Fluent

func seed(database db: any Database) async throws {
	let account = Account(name: "ACME Corporation")
	try await account.create(on: db)

	try await User(
		firstName: "John",
		lastName: "Doe",
		email: "johndoe@example.com",
		plainTextPassword: "secret",
		accountID: account.requireID()
	).create(on: db)

	try await User.factory(amount: 5) { user in
		user.$account.id = try account.requireID()
	}.create(on: db)

	let organizations = try Organization.factory(amount: 100) { organization in
		organization.$account.id = try account.requireID()
	}
	try await organizations.create(on: db)

	try await Contact.factory(amount: 100) { contact in
		contact.$account.id = try account.requireID()
		contact.$organization.id = try organizations.randomElement()!.requireID()
	}.create(on: db)
}
