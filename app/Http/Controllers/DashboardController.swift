import Vapor

enum DashboardController {
	@Sendable static func index(req: Request) async throws -> Response {
		try await req.inertia.render(page: "Dashboard/Index")
	}
}
