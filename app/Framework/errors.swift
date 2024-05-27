import Vapor

protocol RenderableError: Error {
	func render(req: Request) async -> Response
}

struct ErrorRenderer: AsyncMiddleware {
	func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
		return try await Result { try await next.respond(to: request) }
			.flatMapError { error in
				guard let renderableError = error as? RenderableError else {
					return Result { throw error }
				}

				let response = await renderableError.render(req: request)
				response.error = error
				return Result { response }
			}.get()
	}
}

struct ErrorMiddleware: AsyncMiddleware {
	let environment: Environment

	init(in environment: Environment) {
		self.environment = environment
	}

	func handle(_ error: Error, for request: Request) async -> Response {
		let status: HTTPResponseStatus, reason: String, source: ErrorSource
		var headers: HTTPHeaders

		// Inspect the error type and extract what data we can.
		switch error {
			case let debugAbort as (DebuggableError & AbortError):
				(reason, status, headers, source) = (debugAbort.reason, debugAbort.status, debugAbort.headers, debugAbort.source ?? .capture())

			case let abort as AbortError:
				(reason, status, headers, source) = (abort.reason, abort.status, abort.headers, .capture())

			case let debugErr as DebuggableError:
				(reason, status, headers, source) = (debugErr.reason, .internalServerError, [:], debugErr.source ?? .capture())

			default:
				// In debug mode, provide the error description; otherwise hide it to avoid sensitive data disclosure.
				reason = environment.isRelease ? "Something went wrong." : String(describing: error)
				(status, headers, source) = (.internalServerError, [:], .capture())
		}

		// Report the error
		request.logger.report(error: error, file: source.file, function: source.function, line: source.line)

		return Response(status: status, headers: headers, body: .init(string: reason))
	}

	func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
		let response = await Result { try await next.respond(to: request) }
			.orElse { error in await handle(error, for: request) }

		// Renderable errors aren't thrown, but they still need to be reported
		if let error = response.error {
			_ = await handle(error, for: request)
		}

		return response
	}
}

extension Response {
	var error: Error? {
		get { storage[ErrorKey.self] }
		set { storage[ErrorKey.self] = newValue }
	}

	struct ErrorKey: StorageKey {
		typealias Value = Error
	}
}

public extension Validation {
	static func fail(for key: ValidationKey, message: String) throws -> Never {
		var validations = Validations()
		validations.add(key, as: String.self, is: !.empty, customFailureDescription: message)
		try validations.validate(json: "{}").assert()

		unreachable()
	}
}

extension ValidationsError: RenderableError {
	var keyedErrors: [String: [String]] {
		failures.reduce(into: [:]) { errors, error in
			let description = error.customFailureDescription ?? error.failureDescription ?? "Invalid Data"

			errors[error.key.stringValue, default: []].append(description)
		}
	}

	func render(req: Vapor.Request) async -> Vapor.Response {
		return try! req.flash("errors", keyedErrors).redirect(.back)
	}
}
