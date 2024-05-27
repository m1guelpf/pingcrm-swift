import Vapor

protocol RenderableError: Error {
	func render(req: Request) async -> Response
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

		if let renderableError = error as? RenderableError {
			return await renderableError.render(req: request)
		}

		return Response(status: status, headers: headers, body: .init(string: reason))
	}

	func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
		return await Result { try await next.respond(to: request) }
			.orElse { error in await handle(error, for: request) }
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
