import Vapor
import Fluent

struct Filters: Content {
	enum Thrashed: String, Content {
		case with
		case only
	}

	let role: String?
	let search: String?
	let thrashed: Thrashed?
}

enum UsersController {
	@Sendable static func index(req: Request) async throws -> Response {
		let user = try req.auth.require(User.self)
		let filters = try req.query.decode(Filters.self)

		let users = try await User.query(on: req.db)
			.filter(\.$account.$id == user.$account.id)
			.paginate(for: req)

		return try await req.inertia.render(page: "Users/Index", [
			"users": users,
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
		let user = try await User.find(from: req)
		try req.auth.require(User.self).authorize(.update, for: user)

		return try await req.inertia.render(page: "Users/Edit", [
			"user": user,
		])
	}

	@Sendable static func update(req: Request) async throws -> Response {
		let user = try await User.find(from: req)
		try req.auth.require(User.self).authorize(.update, for: user)

		try await user.update(with: req.content.decode(UserUpdateRequest.self), on: req.db)
		return try req.flash("success", "User updated").redirect(.back)
	}

	@Sendable static func destroy(req: Request) async throws -> Response {
		let user = try await User.find(from: req)
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
