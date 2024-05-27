import Leaf
import Vapor
import Ziggy
import Fluent
import Inertia
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) async throws {
	// register dependencies
	app.vite.setup()
	app.ziggy.setup()
	app.inertia.setup()

	// setup database
	app.databases.use(.sqlite(.file(app.directory.resourcesDirectory + "db.sqlite")), as: .sqlite)
	app.migrations.add(migrations)

	// setup authentication
	app.sessions.use(.fluent)
	app.middleware.use(app.sessions.middleware)
	app.middleware.use(FlashMiddleware())
	app.middleware.use(User.asyncSessionAuthenticator())

	// The ErrorRenderer middleware must be placed after the flash and session middlewares,
	// but before other middlewares that might need rendered errors.
	app.middleware.use(ErrorRenderer())

	// inertia data
	app.inertia.share { request in
		[
			"auth": [
				"user": request.auth.get(User.self),
			],
			"flash": [
				"error": request.session.data["error"],
				"success": request.session.data["success"],
			],
			"errors": request.session.data["errors", as: [String: [String]].self],
		]
	}

	// register routes
	try routes(app)
}
