import Vapor
import Fluent

final class User: Model, Content, @unchecked Sendable {
	static let schema = "users"

	@ID(key: .id)
	var id: UUID?

	@Field(key: "first_name")
	var firstName: String

	@Field(key: "last_name")
	var lastName: String

	@Field(key: "email")
	var email: String

	@Field(key: "password")
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
}

extension User: ModelAuthenticatable, ModelSessionAuthenticatable {
	public struct ModelCredentials: Content, Sendable, Validatable {
		public let email: String
		public let password: String

		public static func validations(_ validations: inout Validations) {
			validations.add("email", as: String.self, is: .email)
			validations.add("password", as: String.self, is: !.empty)
		}
	}

	static let usernameKey = \User.$email
	static let passwordHashKey = \User.$password

	func verify(password: String) throws -> Bool {
		try Bcrypt.verify(password, created: self.password)
	}
}
