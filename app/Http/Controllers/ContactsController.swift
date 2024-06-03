import Vapor
import Fluent

enum ContactsController {
	@Sendable static func index(req: Request) async throws -> Response {
		let user = try req.auth.require(User.self)
		let filters = try req.query.decode(Filters.self)

		let contacts = try await Contact.query(on: req.db)
			.with(\.$organization)
			.filter(\.$account.$id == user.$account.id)
			.filtered(by: filters)
			.paginate(for: req)

		return try await req.inertia.render(page: "Contacts/Index", [
			"filters": filters,
			"contacts": contacts,
		])
	}

	@Sendable static func create(req: Request) async throws -> Response {
		try await req.inertia.render(page: "Contacts/Create")
	}

	@Sendable static func store(req: Request) async throws -> Response {
		// @TODO: implement store

		return try req.flash("success", "Contact created").redirect(route: "contacts")
	}

	@Sendable static func edit(req: Request) async throws -> Response {
		let contact = try await Contact.find(from: req)
		let organizations = try await Organization.query(on: req.db)
			.filter(\.$account.$id == contact.$account.id)
			.all()

		return try await req.inertia.render(page: "Contacts/Edit", [
			"contact": contact,
			"organizations": organizations,
		])
	}

	@Sendable static func update(req: Request) async throws -> Response {
		return try req.flash("success", "Contact updated").redirect(.back)
	}

	@Sendable static func destroy(req: Request) async throws -> Response {
		let contact = try await Contact.find(from: req)
		try req.auth.require(User.self).authorize(.delete, for: contact)

		try await contact.delete(on: req.db)

		return try req.flash("success", "Contact deleted").redirect(.back)
	}

	@Sendable static func restore(req: Request) async throws -> Response {
		let contactId = try UUID(uuidString: req.parameters.get("id")!).unwrap(or: Abort(.notFound))
		let contact = try await Contact.query(on: req.db)
			.filter(\.$id == contactId)
			.withDeleted()
			.firstOrFail()

		try req.auth.require(User.self).authorize(.delete, for: contact)

		try await contact.restore(on: req.db)
		return try req.flash("success", "Contact restored").redirect(.back)
	}
}
