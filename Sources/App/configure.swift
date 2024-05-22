import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.vite.setup()
    app.inertia.setup()


    try routes(app)
}
