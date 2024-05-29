import Vapor
import Fluent
import Fakery

public protocol ModelFactory: Model {
	typealias Faker = Fakery.Faker

	init(faker: Faker) throws
}

public extension ModelFactory {
	static func factory(amount: Int = 1, with modifying: (inout Self) throws -> Void = { _ in }) throws -> [Self] {
		let faker = Faker()

		var models: [Self] = []
		for _ in 0..<amount {
			var model = try Self(faker: faker)
			try modifying(&model)
			models.append(model)
		}

		return models
	}
}

struct SeedCommand: AsyncCommand {
	struct Signature: CommandSignature {}

	var help: String {
		"Seed the database with records."
	}

	func run(using context: CommandContext, signature _: Signature) async throws {
		let bar = context.console.loadingBar(title: "Seeding database...")
		bar.start()

		let duration = try await ContinuousClock().measure {
			try await seed(database: context.application.db)
		}
		bar.succeed()

		context.console.info("Took \(duration).")
		context.console.success("Database seeded.")
	}
}
