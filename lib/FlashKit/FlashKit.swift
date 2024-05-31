import Vapor

public extension Request {
	var flash: FlashStorage {
		get {
			if let existing = storage[FlashKey.self] {
				return existing
			} else {
				let new = FlashStorage(request: self)
				storage[FlashKey.self] = new
				return new
			}
		}
		set {
			storage[FlashKey.self] = newValue
		}
	}

	struct FlashStorage: Sendable {
		private static let flashSessionKey = "_flash"

		private let req: Request

		private var oldKeys: [String] = []
		private var newKeys: [String] = []

		fileprivate init(request req: Request) {
			self.req = req

			if let oldKeysFromSession = try? req.session.data.get(Self.flashSessionKey, as: [String].self) {
				oldKeys = oldKeysFromSession
			}
		}

		mutating func ageData() {
			for key in oldKeys {
				req.session.data[key] = nil
			}

			oldKeys = newKeys
			newKeys = []
		}

		func save() throws {
			req.session.data[Self.flashSessionKey] = nil

			if !oldKeys.isEmpty {
				try req.session.data.set(Self.flashSessionKey, oldKeys)
			}
		}

		mutating func reflash() {
			newKeys.append(contentsOf: oldKeys)
			oldKeys = []
		}

		mutating func keep(_ keys: [String]) {
			newKeys.append(contentsOf: keys)
			oldKeys.removeAll { keys.contains($0) }
		}

		mutating func keep(_ key: String) {
			keep([key])
		}

		mutating func now<E: Encodable>(key: String, value: E) throws {
			try req.session.data.set(key, value)

			oldKeys.append(key)
		}

		mutating func store<E: Encodable>(key: String, value: E) throws {
			try req.session.data.set(key, value)

			newKeys.append(key)
			oldKeys.removeAll { $0 == key }
		}
	}

	private struct FlashKey: StorageKey {
		public typealias Value = FlashStorage
	}
}

public struct FlashMiddleware: AsyncMiddleware {
	public init() {}

	public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
		if request.hasSession {
			request.flash = .init(request: request)
		}

		let response = try await next.respond(to: request)

		if request.hasSession {
			request.flash.ageData()
			try request.flash.save()
		}

		return response
	}
}

public extension Request {
	@discardableResult
	func flash(_ key: String, _ value: Encodable) throws -> Request {
		try flash.store(key: key, value: value)

		return self
	}
}
