import Vapor
import Logging
import NIOCore
import NIOPosix

@main
private class Entrypoint {
	static func main() async throws {
		var env = try Environment.detect()
		try LoggingSystem.bootstrap(from: &env)

		let app = try await Application.make(env)

		// This attempts to install NIO as the Swift Concurrency global executor.
		// You should not call any async functions before this point.
		let executorTakeoverSuccess = NIOSingletons.unsafeTryInstallSingletonPosixEventLoopGroupAsConcurrencyGlobalExecutor()
		app.logger.debug("Running with \(executorTakeoverSuccess ? "SwiftNIO" : "standard") Swift Concurrency default executor")

		do {
			try await prepare(app)
			try await configure(app)
		} catch {
			app.logger.report(error: error)
			try? await app.asyncShutdown()
			throw error
		}
		try await app.execute()
		try await app.asyncShutdown()
	}

	static func prepare(_ app: Application) async throws {
		// adjust directory structure
		app.directory.reconfigure()

		// setup error handling
		app.middleware = .init()
		app.middleware.use(RouteLoggingMiddleware(logLevel: .info))
		app.middleware.use(ErrorMiddleware(in: app.environment))

		// register seeding command
		app.asyncCommands.use(SeedCommand(), as: "seed")
	}
}
