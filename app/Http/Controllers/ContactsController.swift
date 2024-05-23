import Vapor

enum ContactsController {
    @Sendable static func index(req: Request) async throws -> Response {
        let emptyArrayPlaceholder: [String] = []

        return try await req.inertia.render(page: "Contacts/Index", [
            "filters": emptyArrayPlaceholder, // get search, thrashed from query
            "contacts": emptyArrayPlaceholder, // paginated and filtered contacts
        ])
    }

    @Sendable static func create(req: Request) async throws -> Response {
        try await req.inertia.render(page: "Contacts/Create")
    }

    @Sendable static func store(req: Request) async throws -> Response {
        // @TODO: implement store

        return try req.flash("success", "Contact created").redirect(to: "/contacts")
    }

    @Sendable static func edit(req: Request) async throws -> Response {
        // @TODO: implement contact fetching
        let contact: Contact? = nil

        return try await req.inertia.render(page: "Contacts/Edit", [
            "contact": contact,
        ])
    }

    @Sendable static func update(req: Request) async throws -> Response {
        return try req.flash("success", "Contact updated").redirect(.back)
    }

    @Sendable static func destroy(req: Request) async throws -> Response {
        // @TODO: implement contact deletion

        return try req.flash("success", "Contact deleted").redirect(.back)
    }

    @Sendable static func restore(req: Request) async throws -> Response {
        // @TODO: implement contact restoration

        return try req.flash("success", "Contact restored").redirect(.back)
    }
}
