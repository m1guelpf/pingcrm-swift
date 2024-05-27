import Vapor

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()

public extension SessionData {
	func get<T: Decodable>(_ key: String, as _: T.Type) throws -> T? {
		guard let value = self[key]?.data(using: .utf8) else {
			return nil
		}

		return try decoder.decode(T.self, from: value)
	}

	func get<T: Decodable>(_ key: String) throws -> T? {
		try get(key, as: T.self)
	}

	mutating func set<T: Encodable>(_ key: String, _ value: T?) throws {
		guard let value else {
			self[key] = nil
			return
		}

		self[key] = try String(data: encoder.encode(value), encoding: .utf8)!
	}

	subscript<T: Decodable>(_ key: String, as _: T.Type) -> T? {
		return try? get(key)
	}
}
