import Vapor

public extension Authenticatable {
	static func requireAuth(
		redirectsTo redirect: URI = URI(path: "/login")
	) -> AsyncMiddleware {
		return AuthMiddleware<Self>(redirectsTo: redirect)
	}

	static func ensureGuest(
		redirectsTo redirect: URI = URI(path: "/")
	) -> AsyncMiddleware {
		return GuestMiddleware<Self>(redirectsTo: redirect)
	}
}

private final class AuthMiddleware<A>: AsyncMiddleware where A: Authenticatable {
	/// The URI to redirect to if the user is not authenticated.
	private let redirect: URI

	/// Creates a new `AuthMiddleware`.
	///
	/// - parameters:
	///     - type: `Authenticatable` type to ensure is authed.
	///     - redirect: URI to redirect to if not authed.
	init(_: A.Type = A.self, redirectsTo redirect: URI) {
		self.redirect = redirect
	}

	public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
		guard request.auth.has(A.self) else {
			return request.redirect(to: redirect.string)
		}

		return try await next.respond(to: request)
	}
}

private final class GuestMiddleware<A>: AsyncMiddleware where A: Authenticatable {
	/// The URI to redirect to if the user is authenticated.
	private let redirect: URI

	/// Creates a new `GuestMiddleware`.
	///
	/// - parameters:
	///     - type: `Authenticatable` type to ensure is authed.
	///     - redirect: URI to redirect to if authed.
	init(_: A.Type = A.self, redirectsTo redirect: URI) {
		self.redirect = redirect
	}

	public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
		guard !request.auth.has(A.self) else {
			return request.redirect(to: redirect.string)
		}

		return try await next.respond(to: request)
	}
}
