import Vapor
import Fluent

enum LoginController {
	/// Display the login view.
	@Sendable static func index(req: Request) async throws -> Response {
		return try await req.inertia.render(page: "Auth/Login")
	}

	/// Handle an incoming authentication request.
	@Sendable static func store(req: Request) async throws -> Response {
		try User.ModelCredentials.validate(content: req)
		let credentials = try req.content.decode(User.ModelCredentials.self)
		guard let user = try await User.query(on: req.db).filter(\.$email == credentials.email).first(), try user.verify(password: credentials.password) else {

			throw Abort(.unauthorized)
		}

		req.auth.login(user)
		return req.redirect(route: "dashboard")
	}

	/// Destroy an authenticated session.
	@Sendable static func destroy(req: Request) async throws -> Response {
		req.auth.logout(User.self)
		req.session.destroy()

		return req.redirect(route: "login")
	}
}
