import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        return try await req.inertia.render(page: "Index", ["title": "Hello World!"])
    }

    app.get("hello") { req async throws -> String in
        try String(data: req.application.vite.content(asset: "Resources/Frontend/app.ts"), encoding: .utf8) ?? ""
    }
}
