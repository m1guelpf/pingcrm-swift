import Vapor
import Fluent

struct Filters: Content {
	enum Thrashed: String, Content {
		case with
		case only
	}

	let role: String?
	let search: String
	let thrashed: Thrashed?
}

enum UsersController {
	@Sendable static func index(req: Request) async throws -> Response {
		let filters = try req.query.decode(Filters.self)
		let emptyArrayPlaceholder: [String] = []

		return try await req.inertia.render(page: "Users/Index", [
			"users": emptyArrayPlaceholder, // paginated and filtered users
			"filters": filters,
		])
	}

	@Sendable static func create(req: Request) async throws -> Response {
		return try await req.inertia.render(page: "Users/Create")
	}

	@Sendable static func store(req: Request) async throws -> Response {
		// @TODO: implement store

		return try req.flash("success", "User created").redirect(route: "users")
	}

	@Sendable static func edit(req: Request) async throws -> Response {
		let userId = UUID(uuidString: req.parameters.get("id")!)
		let user = try await User.find(userId, on: req.db).unwrap(or: Abort(.notFound))

		try req.auth.require(User.self).authorize(.update, for: user)

		return try await req.inertia.render(page: "Users/Edit", [
			"user": user,
		])
	}

	@Sendable static func update(req: Request) async throws -> Response {
		let userId = UUID(uuidString: req.parameters.get("id")!)
		let user = try await User.find(userId, on: req.db).unwrap(or: Abort(.notFound))

		try req.auth.require(User.self).authorize(.update, for: user)

		return try req.flash("success", "User updated").redirect(.back)
	}

	@Sendable static func destroy(req: Request) async throws -> Response {
		let userId = UUID(uuidString: req.parameters.get("id")!)
		let user = try await User.find(userId, on: req.db).unwrap(or: Abort(.notFound))

		try req.auth.require(User.self).authorize(.delete, for: user)

		try await user.delete(on: req.db)

		return try req.flash("success", "User deleted").redirect(.back)
	}

	@Sendable static func restore(req: Request) async throws -> Response {
		let userId = try UUID(uuidString: req.parameters.get("id")!).unwrap(or: Abort(.notFound))
		let user = try await User.query(on: req.db)
			.filter(\User.$id == userId)
			.withDeleted()
			.firstOrFail()

		try req.auth.require(User.self).authorize(.delete, for: user)

		try await user.restore(on: req.db)

		return try req.flash("success", "User restored").redirect(.back)
	}
}
