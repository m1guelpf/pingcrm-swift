import Vapor
import Fluent

final class Organization: Model, Content, @unchecked Sendable {
	static let schema = "organizations"

	@ID(key: .id)
	var id: UUID?

	@Field(key: "name")
	var name: String

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

	@Children(for: \.$organization)
	var contacts: [Contact]

	init() {}

	init(id: UUID? = nil, name: String, email: String?, phone: String?, address: String?, city: String?, region: String?, country: String?, postalCode: String?, accountID: UUID) {
		self.id = id
		self.name = name
		self.city = city
		self.email = email
		self.phone = phone
		self.region = region
		self.address = address
		self.country = country
		$account.id = accountID
		self.postalCode = postalCode
	}
}

extension Organization: ModelFactory {
	convenience init(faker: Faker) throws {
		self.init()
		name = faker.company.name()
		city = faker.address.city()
		region = faker.address.state()
		country = faker.address.country()
		email = faker.internet.safeEmail()
		postalCode = faker.address.postcode()
		phone = faker.phoneNumber.phoneNumber()
		address = faker.address.streetAddress()
	}
}
