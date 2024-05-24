import Vapor

public extension Request {
	func flash(_: String, _: Encodable) throws -> Request {
		fatalError("flashing data to the session is not implemented yet")

		return self
	}
}
