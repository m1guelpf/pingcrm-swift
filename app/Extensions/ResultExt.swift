public extension Result where Failure == Swift.Error {
	init(catching body: () async throws -> Success) async {
		do {
			self = try .success(await body())
		} catch {
			self = .failure(error)
		}
	}

	@inlinable func flatMapError<NewFailure>(_ transform: (Failure) async -> Result<Success, NewFailure>) async -> Result<Success, NewFailure> where NewFailure: Error {
		switch self {
			case let .success(success):
				return .success(success)
			case let .failure(failure):
				return await transform(failure)
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
