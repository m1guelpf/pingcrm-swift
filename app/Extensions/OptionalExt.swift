extension Optional {
	func orElse(_ f: () -> Wrapped) -> Wrapped {
		switch self {
			case let .some(value):
				return value
			case .none:
				return f()
		}
	}

	func unwrap<E: Error>(or error: E) throws -> Wrapped {
		switch self {
			case let .some(value):
				return value
			case .none:
				throw error
		}
	}
}
