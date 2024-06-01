import Vapor
import Fluent

struct UserUpdateRequest: Content, Validatable {
	let firstName: String
	let lastName: String
	let email: String
	let owner: Bool
	let password: String?
	let photo: String?

	static func validations(_ validations: inout Validations) {
		validations.add("firstName", as: String.self, is: !.empty && .count(...50))
		validations.add("lastName", as: String.self, is: !.empty && .count(...50))
		validations.add("email", as: String.self, is: .email, required: false)
		validations.add("owner", as: Bool.self, is: .valid, required: true)
		validations.add("photo", as: String.self, is: .url, required: false)
		validations.add("password", as: String.self, is: .count(8...50), required: false)
	}

	func update(_ user: inout User) throws {
		user.firstName = firstName
		user.lastName = lastName
		user.owner = owner

		if let photo = photo {
			user.photo = photo
		}

		if let password = password {
			user.password = try Bcrypt.hash(password)
		}
	}
}

extension User {
	func update(with data: UserUpdateRequest, on database: any Database) async throws {
		firstName = data.firstName
		lastName = data.lastName
		owner = data.owner

		if let photo = data.photo {
			self.photo = photo
		}

		if let password = data.password {
			self.password = try Bcrypt.hash(password)
		}

		try await update(on: database)
	}
}
