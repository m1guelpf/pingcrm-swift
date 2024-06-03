import Vapor
import Fluent

enum OrganizationsController {
	@Sendable static func index(req: Request) async throws -> Response {
		let user = try req.auth.require(User.self)
		let filters = try req.query.decode(Filters.self)

		let organizations = try await Organization.query(on: req.db)
			.filter(\.$account.$id == user.$account.id)
			.paginate(for: req)

		return try await req.inertia.render(page: "Organizations/Index", [
			"filters": filters,
			"organizations": organizations,
		])
	}

	@Sendable static func create(req: Request) async throws -> Response {
		try await req.inertia.render(page: "Organizations/Create")
	}

	@Sendable static func store(req: Request) async throws -> Response {
		// @TODO: implement store

		return try req.flash("success", "Organization created").redirect(route: "organizations")
	}

	@Sendable static func edit(req: Request) async throws -> Response {
		let organization = try await Organization.find(from: req, with: \.$contacts)

		return try await req.inertia.render(page: "Organizations/Edit", [
			"organization": organization,
		])
	}

	@Sendable static func update(req: Request) async throws -> Response {
		return try req.flash("success", "Organization updated").redirect(.back)
	}

	@Sendable static func destroy(req: Request) async throws -> Response {
		// @TODO: implement organization deletion

		return try req.flash("success", "Organization deleted").redirect(.back)
	}

	@Sendable static func restore(req: Request) async throws -> Response {
		// @TODO: implement organization restoration

		return try req.flash("success", "Organization restored").redirect(.back)
	}
}
