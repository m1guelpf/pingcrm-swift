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
	app.middleware.use(User.asyncSessionAuthenticator())

	// register routes
	try routes(app)
}
