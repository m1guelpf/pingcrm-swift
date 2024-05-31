import Vapor
import Fluent
import PolicyKit

final class Contact: Model, Content, @unchecked Sendable {
	static let schema = "contacts"

	@ID(key: .id)
	var id: UUID?

	@Field(key: "first_name")
	var firstName: String

	@Field(key: "last_name")
	var lastName: String

	@Field(key: "email")
	var email: String?

	@Field(key: "phone")
	var phone: String?

	@Field(key: "address")
	var address: String?

	@Field(key: "city")
	var city: String?

	@Field(key: "region")
	var region: String?

	@Field(key: "country")
	var country: String?

	@Field(key: "postal_code")
	var postalCode: String?

	@Timestamp(key: "created_at", on: .create)
	var createdAt: Date?

	@Timestamp(key: "updated_at", on: .update)
	var updatedAt: Date?

	@Timestamp(key: "deleted_at", on: .delete)
	var deletedAt: Date?

	@Parent(key: "account_id")
	var account: Account

	@Parent(key: "organization_id")
	var organization: Organization

	init() {}

	init(id: UUID? = nil, firstName: String, lastName: String, email: String?, phone: String?, address: String?, city: String?, region: String?, country: String?, postalCode: String?) {
		self.id = id
		self.city = city
		self.email = email
		self.phone = phone
		self.region = region
		self.country = country
		self.address = address
		self.lastName = lastName
		self.firstName = firstName
		self.postalCode = postalCode
	}
}

extension Contact: ModelPolicy {
	enum Action {
		case view
		case update
		case delete
		case restore
	}

	func can(authenticated user: User, do _: Action) -> Bool {
		return user.$account.id == account.id
	}
}

extension Contact: ModelFactory {
	convenience init(faker: Faker) throws {
		self.init()
		city = faker.address.city()
		region = faker.address.state()
		lastName = faker.name.lastName()
		country = faker.address.country()
		email = faker.internet.safeEmail()
		firstName = faker.name.firstName()
		postalCode = faker.address.postcode()
		phone = faker.phoneNumber.phoneNumber()
		address = faker.address.streetAddress()
	}
}
