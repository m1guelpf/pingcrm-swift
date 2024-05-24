import Vapor

enum UsersController {
	@Sendable static func index(req: Request) async throws -> Response {
		let emptyArrayPlaceholder: [String] = []

		return try await req.inertia.render(page: "Users/Index", [
			"users": emptyArrayPlaceholder, // paginated and filtered users
			"filters": emptyArrayPlaceholder, // get search, role, thrashed from query
		])
	}

	@Sendable static func create(req: Request) async throws -> Response {
		try await req.inertia.render(page: "Users/Create")
	}

	@Sendable static func store(req: Request) async throws -> Response {
		// @TODO: implement store

		return try req.flash("success", "User created").redirect(route: "users")
	}

	@Sendable static func edit(req: Request) async throws -> Response {
		// @TODO: implement user fetching
		let user: User? = nil

		return try await req.inertia.render(page: "Users/Edit", [
			"user": user,
		])
	}

	@Sendable static func update(req: Request) async throws -> Response {
		return try req.flash("success", "User updated").redirect(.back)
	}

	@Sendable static func destroy(req: Request) async throws -> Response {
		// @TODO: implement user deletion

		return try req.flash("success", "User deleted").redirect(.back)
	}

	@Sendable static func restore(req: Request) async throws -> Response {
		// @TODO: implement user restoration

		return try req.flash("success", "User restored").redirect(.back)
	}
}
