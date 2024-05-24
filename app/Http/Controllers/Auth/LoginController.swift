import Vapor

enum LoginController {
	/// Display the login view.
	@Sendable static func index(req: Request) async throws -> Response {
		return try await req.inertia.render(page: "Auth/Login")
	}

	/// Handle an incoming authentication request.
	@Sendable static func store(req: Request) async throws -> Response {
		// @TODO: implement login

		return req.redirect(route: "dashboard")
	}

	/// Destroy an authenticated session.
	@Sendable static func destroy(req: Request) async throws -> Response {
		req.auth.logout(User.self)
		req.session.destroy()

		return req.redirect(route: "login")
	}
}
