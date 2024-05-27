public extension Result where Failure == Swift.Error {
	init(catching body: () async throws -> Success) async {
		do {
			self = try .success(await body())
		} catch {
			self = .failure(error)
		}
	}

	@inlinable func orElse(_ transform: (Failure) async -> Success) async -> Success {
		switch self {
			case let .success(value):
				return value
			case let .failure(error):
				return await transform(error)
		}
	}
}
