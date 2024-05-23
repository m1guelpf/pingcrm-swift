import Leaf
import Vapor

public extension Route {
	@discardableResult
	func name(_ string: String) -> Route {
		userInfo["name"] = string
		return self
	}
}

extension Application {
	var ziggy: Ziggy {
		.init(application: self)
	}

	struct Ziggy {
		public let application: Application

		var url: String? {
			Environment.get("APP_URL")
		}

		var port: Int? {
			URL(string: url ?? "")?.port
		}

		public func setup() {
			application.leaf.tags["routes"] = ZiggyTag(ziggy: self)
		}

		public func routes() -> [String: Route] {
			return application.routes.all
				.filter { $0.userInfo["name"] != nil }
				.map { ($0.userInfo["name"] as! String, Route($0)) }
				.reduce(into: [String: Route]()) { routes, route in
					if routes[route.0] == nil {
						routes[route.0] = route.1
					} else {
						if routes[route.0]!.uri == route.1.uri {
							routes[route.0]!.methods.append(contentsOf: route.1.methods.filter { !routes[route.0]!.methods.contains($0) })
						} else {
							routes[route.0] = route.1
						}
					}
				}
		}

		public func serialize() -> String {
			let data = try! JSONEncoder().encode(Serialized(url: url, port: port, routes: routes(), defaults: [:]))

			return String(data: data, encoding: .utf8)!
		}

		struct Serialized: Content {
			var url: String?
			var port: Int?
			var routes: [String: Route]
			var defaults: [String: String]
		}

		struct Route: Content {
			var uri: String
			var methods: [String]
			var parameters: [String]?
			var wheres: [String: String]?

			init(_ route: Vapor.Route) {
				uri = route.path.map { component in
					switch component {
						case let .constant(path):
							return path
						case let .parameter(parameter):
							return "{\(parameter)}"
						case .anything:
							return "{wildcard}"
						case .catchall:
							return "{fallbackPlaceholder}"
					}
				}.joined(separator: "/")

				parameters = route.path.compactMap { component in
					switch component {
						case .constant:
							return nil
						case let .parameter(parameter):
							return parameter
						case .anything:
							return "wildcard"
						case .catchall:
							return "fallbackPlaceholder"
					}
				}

				methods = [route.method.string]
				wheres = route.path.filter { $0 == .catchall }.isEmpty ? nil : ["fallbackPlaceholder": ".*"]
			}
		}

		struct ZiggyTag: UnsafeUnescapedLeafTag {
			let ziggy: Ziggy

			func render(_: LeafContext) throws -> LeafData {
				let ziggy = ziggy.serialize()

				return LeafData.string("<script type=\"text/javascript\">const Ziggy=\(ziggy);</script>")
			}
		}
	}
}
