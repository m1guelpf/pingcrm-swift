import Leaf
import Vapor

public extension Application {
    var inertia: Inertia {
        .init(application: self)
    }

    struct Inertia: Sendable {
        public let application: Application

        public func setup() {
            application.middleware.use(InertiaMiddleware(inertia: self))
            application.leaf.tags["inertia"] = InertiaTag(inertia: self)
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

                // handle redirects
                // some more stuff??

                return response
            }
        }
    }
}

public extension Request {
    var inertia: Inertia {
        .init(request: self)
    }

    struct Inertia {
        public let request: Request

        public func render(page: String) async throws -> Response {
            try await render(page: page, nil as String?)
        }

        public func render<E>(page: String, _ data: E) async throws -> Response where E: Encodable {
            let json = try Result { try JSONEncoder().encode(Data(component: page, props: data, url: request.url.string, version: nil)) }
                .mapError { _ in Error.invalidData }
                .get()

            if request.headers.first(name: "X-Inertia") != nil {
                return Response(status: .ok, headers: ["X-Inertia": "true", "Content-Type": "application/json"], body: .init(data: json))
            }

            return try await request.view.render("app", ["_intertiaJson": String(data: json, encoding: .utf8)?.replacingOccurrences(of: "\"", with: "&quot;")])
                .encodeResponse(for: request)
        }

        struct Data<E: Encodable>: Encodable {
            let component: String
            let props: E
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
}
