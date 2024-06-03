import Vapor
import Fluent

struct Filters: Content {
	enum Thrashed: String, Codable {
		case with
		case only
	}

	/// Only valid for users
	let role: String?
	let search: String?
	let thrashed: Thrashed?
}

extension QueryBuilder {
	func filtered(by filters: Filters) -> Self {
		if let thrashed = filters.thrashed {
			switch thrashed {
				case .with:
					withDeleted()
				case .only:
					// @TODO: Implement onlyTrashed
					withDeleted()
			}
		}

		if let search = filters.search {
			// @TODO: Implement search
		}

		return self
	}
}
