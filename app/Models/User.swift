import Vapor
import Fluent
import PolicyKit

final class User: Model, @unchecked Sendable {
	static let schema = "users"

	@ID(key: .id)
	var id: UUID?

	@Field(key: "first_name")
	var firstName: String

	@Field(key: "last_name")
	var lastName: String

	@Field(key: "email")
	var email: String

	@PrivateField(key: "password")
	var password: String

	@Field(key: "owner")
	var owner: Bool

	@Field(key: "photo")
	var photo: String?

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	@Timestamp(key: "updated_at", on: .update)
	var updatedAt: Date?

	@Timestamp(key: "deleted_at", on: .delete)
	var deletedAt: Date?

	@Parent(key: "account_id")
	var account: Account

	init() {}

	init(id: UUID? = nil, firstName: String, lastName: String, email: String, hashedPassword: String, owner: Bool = false, photo: String? = nil, accountID: UUID) {
		self.id = id
		self.lastName = lastName
		self.firstName = firstName
		self.email = email
		password = hashedPassword
		self.owner = owner
		self.photo = photo
		$account.id = accountID
	}

	init(id: UUID? = nil, firstName: String, lastName: String, email: String, plainTextPassword: String, owner: Bool = false, photo: String? = nil, accountID: UUID) throws {
		self.id = id
		self.lastName = lastName
		self.firstName = firstName
		self.email = email
		password = try Bcrypt.hash(plainTextPassword)
		self.owner = owner
		self.photo = photo
		$account.id = accountID
	}
}

extension User: Authorizable, ModelAuthenticatable, ModelSessionAuthenticatable {
	public struct ModelCredentials: Content, Sendable, Validatable {
		public let email: String
		public let password: String

		public static func validations(_ validations: inout Validations) {
			validations.add("email", as: String.self, is: .email)
			validations.add("password", as: String.self, is: !.empty)
		}
	}

	// `passwordHashKey` is not used anywhere, but is required to be a string, so we cheat and re-use the email key.
	static let passwordHashKey = \User.$email
	static let usernameKey = \User.$email

	func verify(password: String) throws -> Bool {
		try Bcrypt.verify(password, created: self.password)
	}
}

extension User: ModelPolicy {
	enum Action {
		case view
		case update
		case delete
		case restore
	}

	func can(authenticated user: User, do _: Action) -> Bool {
		return user.$account.id == $account.id
	}
}

extension User: ModelFactory {
	convenience init(faker: Faker) throws {
		self.init()

		owner = false
		photo = faker.internet.image()
		lastName = faker.name.lastName()
		firstName = faker.name.firstName()
		email = faker.internet.safeEmail()
		password = try Bcrypt.hash(faker.internet.password())
	}
}
