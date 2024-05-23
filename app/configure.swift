import Leaf
import Vapor
import Inertia

// configures your application
public func configure(_ app: Application) async throws {
	// adjust directory structure
	app.directory.reconfigure()

	// register dependencies
	app.vite.setup()
	app.ziggy.setup()
	app.inertia.setup()

	// setup authentication
	app.sessions.use(.memory) // switch to Fluent later
	app.passwords.use(.bcrypt)
	app.middleware.use(app.sessions.middleware)
	app.middleware.use(UserSessionAuthenticator())

	// register routes
	try routes(app)
}
