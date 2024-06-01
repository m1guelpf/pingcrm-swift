import Vapor
import Fluent
import Fakery

public extension Request {
	enum RedirectBack {
		case back
	}

	func redirect(_: RedirectBack, redirectType: Redirect = .normal) -> Response {
		return redirect(to: headers.first(name: .referer) ?? url.string, redirectType: redirectType)
	}
}

extension DirectoryConfiguration {
	mutating func reconfigure() {
		publicDirectory = workingDirectory + "public/"
		resourcesDirectory = workingDirectory + "resources/"
		viewsDirectory = resourcesDirectory + "views/"
	}
}

/// An unreachable code path.
///
/// This can be used for whenever the compiler can't determine that a path is unreachable, such as dynamically terminating an iterator.
@inline(__always)
public func unreachable() -> Never {
	return unsafeBitCast((), to: Never.self)
}

/// Asserts that the code path is unreachable.
///
/// Calls `assertionFailure(_:file:line:)` in unoptimized builds and `unreachable()` otherwise.
///
/// - parameter message: The message to print. The default is "Encountered unreachable path".
/// - parameter file: The file name to print with the message. The default is the file where this function is called.
/// - parameter line: The line number to print with the message. The default is the line where this function is called.
@inline(__always)
public func assertUnreachable(_ message: String = "Encountered unreachable path", file: StaticString = #file, line: UInt = #line) -> Never {
	var isDebug = false
	assert({ isDebug = true; return true }())

	if isDebug {
		fatalError(message, file: file, line: line)
	} else {
		unreachable()
	}
}

/// The error type for errors that can never happen.
///
/// Since this enum has no variant, a value of this type can never actually exist.
/// This can be useful for generic APIs that use [`Result`] and parameterize the error type, to indicate that the result is always [`success`].
public enum Infallible: Error {
	init() {
		assertUnreachable("Attempted to create an instance of Infallible")
	}
}

public extension Result where Failure == Infallible {
	@inlinable func unwrap() -> Success {
		switch self {
			case let .success(value):
				return value
		}
	}
}

public extension QueryBuilder {
	func firstOrFail(error: Error = Abort(.notFound)) async throws -> Model {
		guard let model = try await first() else {
			throw error
		}

		return model
	}
}

public extension Model where IDValue == UUID {
	static func find(from request: Request) async throws -> Self {
		guard let id = request.parameters.get("id") else {
			throw Abort(.badRequest)
		}

		guard let uuid = UUID(uuidString: id) else {
			throw Abort(.badRequest)
		}

		return try await Self.find(uuid, on: request.db).unwrap(or: Abort(.notFound))
	}
}

public extension Faker.Internet {
	func image(width: Int = 320, height: Int = 200) -> String {
		return "https://picsum.photos/\(width)/\(height)?random=\(UUID().uuidString)"
	}
}

extension Fluent.PageMetadata: @unchecked Sendable {}
extension Fluent.Page: @unchecked Sendable where T: Sendable {}
