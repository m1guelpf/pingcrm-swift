import Vapor
import Fluent

final class Account: Model, Content, @unchecked Sendable {
	static let schema = "accounts"

	@ID(key: .id)
	var id: UUID?

	@Field(key: "name")
	var name: String

	@Children(for: \.$account)
	var users: [User]

	init() {}

	init(id: UUID? = nil, name: String) {
		self.id = id
		self.name = name
	}
}
