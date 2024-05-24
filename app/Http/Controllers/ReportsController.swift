import Vapor

enum ReportsController {
	@Sendable static func index(req: Request) async throws -> Response {
		try await req.inertia.render(page: "Reports/Index")
	}
}
