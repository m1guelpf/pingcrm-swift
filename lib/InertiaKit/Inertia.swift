import Leaf
import Vapor

enum Headers {
	static let INERTIA = "X-Inertia"
	static let VERSION = "X-Inertia-Version"
	static let LOCATION = "X-Inertia-Location"
}

public extension Application {
	var inertia: Inertia {
		get {
			if let existing = storage[InertiaKey.self] {
				return existing
			} else {
				let new = Inertia(application: self)
				storage[InertiaKey.self] = new
				return new
			}
		}
		set {
			storage[InertiaKey.self] = newValue
		}
	}

	struct Inertia: Sendable {
		public let application: Application

		/// The root template that's loaded on the first page visit.
		public var rootView: String = "app"

		/// Determines the current asset version.
		/// @see https://inertiajs.com/asset-versioning
		public var version: @Sendable (Request) -> String? = { req in req.application.vite.version() }

		var sharedProps: [@Sendable (Request) -> [String: Encodable & Sendable]] = []

		public func setup() {
			application.middleware.use(InertiaMiddleware(inertia: self))
			application.leaf.tags["inertia"] = InertiaTag(inertia: self)
		}

		public mutating func share(_ values: @escaping @Sendable (Request) -> [String: Encodable]) {
			sharedProps.append(values)
		}

		public mutating func share(_ key: String, _ value: @escaping @Sendable (Request) -> Encodable & Sendable) {
			sharedProps.append { req in [key: value(req)] }
		}

		public mutating func share(_ key: String, _ value: Encodable & Sendable) {
			sharedProps.append { _ in [key: value] }
		}

		fileprivate func sharedProps(for request: Request) -> [String: Encodable & Sendable] {
			sharedProps.reduce(into: [:]) { $0.merge($1(request)) { _, new in new } }
		}

		struct InertiaTag: UnsafeUnescapedLeafTag {
			let inertia: Inertia

			func render(_ ctx: LeafContext) throws -> LeafData {
				let id = ctx.parameters[safe: 0]?.string ?? "app"
				let data = ctx.data["_intertiaJson"]?.string ?? "{}"

				return LeafData.string("<div id=\"\(id)\" data-page=\"\(data.replacingOccurrences(of: "\"", with: "\\\""))\"></div>")
			}
		}

		struct InertiaMiddleware: AsyncMiddleware {
			let inertia: Inertia

			func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
				let response = try await next.respond(to: request)
				response.headers.add(name: .vary, value: Headers.INERTIA)

				if !request.isInertia {
					return response
				}

				if request.method == .GET && request.headers.first(name: Headers.VERSION) != inertia.version(request) {
					// @TODO: figure out how to reflash session without requiring Flash dependency

					return request.inertia.redirect(to: request.url)
				}

				if response.status.isSuccess && response.body.isEmpty {
					return request.redirect(to: request.url.string)
				}

				return response
			}
		}
	}

	struct InertiaKey: StorageKey {
		public typealias Value = Inertia
	}
}

public extension Request {
	var inertia: Inertia {
		get {
			if let existing = storage[InertiaKey.self] {
				return existing
			} else {
				let new = Inertia(request: self)
				storage[InertiaKey.self] = new
				return new
			}
		}
		set {
			storage[InertiaKey.self] = newValue
		}
	}

	var isInertia: Bool {
		headers.first(name: Headers.INERTIA) != nil
	}

	struct Inertia: Sendable {
		public let request: Request
		var sharedProps: [String: Encodable & Sendable] = [:]

		init(request: Request) {
			self.request = request
		}

		var inertia: Application.Inertia {
			request.application.inertia
		}

		var version: String? {
			request.application.inertia.version(request)
		}

		@discardableResult
		public mutating func share(_ values: [String: Encodable & Sendable]) -> Self {
			sharedProps.merge(values) { _, new in new }

			return self
		}

		@discardableResult
		public mutating func share(_ key: String, _ value: Encodable & Sendable) -> Self {
			sharedProps[key] = value

			return self
		}

		public func redirect(to location: URI) -> Response {
			redirect(to: location.string)
		}

		public func redirect(to location: String) -> Response {
			if request.isInertia {
				return Response(status: .conflict, headers: [Headers.LOCATION: location], body: .empty)
			}

			return request.redirect(to: location)
		}

		public func render(page: String, _ data: [String: Encodable & Sendable] = [:], status: HTTPResponseStatus = .ok) async throws -> Response {
			let props = EncodableDictionary(
				sharedProps
					.merging(data) { _, new in new }
					.merging(request.application.inertia.sharedProps(for: request)) { old, _ in old }
			)

			let json = try Result { try JSONEncoder().encode(Data(component: page, props: props, url: request.url.string, version: version)) }
				.mapError { _ in Error.invalidData }
				.get()

			if request.isInertia {
				return Response(status: status, headers: [Headers.INERTIA: "true", "Content-Type": "application/json"], body: .init(data: json))
			}

			return try await request.view.render(inertia.rootView, ["_intertiaJson": String(data: json, encoding: .utf8)?.replacingOccurrences(of: "\"", with: "&quot;")])
				.encodeResponse(for: request).get()
				.withStatus(status)
		}

		struct Data: Encodable {
			let component: String
			let props: EncodableDictionary
			let url: String
			let version: String?
		}

		enum Error: Swift.Error, DebuggableError {
			case invalidData

			static var readableName: String {
				"Inertia Error"
			}

			public var identifier: String {
				switch self {
					case .invalidData:
						return "invalidData"
				}
			}

			public var reason: String {
				switch self {
					case .invalidData:
						return "The provided data could not be encoded."
				}
			}
		}
	}

	struct InertiaKey: StorageKey {
		public typealias Value = Inertia
	}
}
