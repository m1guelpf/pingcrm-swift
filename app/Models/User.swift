import Vapor

struct User: Content {
    var id: UUID
}

extension User: SessionAuthenticatable {
    var sessionID: String { id.uuidString }
}
