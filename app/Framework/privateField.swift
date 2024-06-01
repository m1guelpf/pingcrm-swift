import FluentKit

public extension Fields {
	typealias PrivateField<Value> = PrivateFieldProperty<Self, Value> where Value: Codable & Sendable
}

// MARK: Type

@propertyWrapper
public final class PrivateFieldProperty<Model, Value>: @unchecked Sendable where Model: Fields, Value: Codable & Sendable {
	public let key: FieldKey
	var outputValue: Value?
	var inputValue: DatabaseQuery.Value?

	public var projectedValue: PrivateFieldProperty<Model, Value> {
		self
	}

	public var wrappedValue: Value {
		get {
			guard let value = value else {
				fatalError("Cannot access field before it is initialized or fetched: \(key)")
			}

			return value
		}
		set {
			value = newValue
		}
	}

	public init(key: FieldKey) {
		self.key = key
	}
}

extension PrivateFieldProperty: CustomStringConvertible {
	public var description: String {
		"@\(Model.self).PrivateField<\(Value.self)>(key: \(key))"
	}
}

// MARK: Property

extension PrivateFieldProperty: AnyProperty {}

extension PrivateFieldProperty: Property {
	public var value: Value? {
		get {
			if let value = inputValue {
				switch value {
					case let .bind(bind):
						return bind as? Value
					case let .enumCase(string):
						return string as? Value
					case .default:
						fatalError("Cannot access default field for '\(Model.self).\(key)' before it is initialized or fetched")
					default:
						fatalError("Unexpected input value type for '\(Model.self).\(key)': \(value)")
				}
			} else if let value = outputValue {
				return value
			} else {
				return nil
			}
		}
		set {
			inputValue = newValue.map { .bind($0) }
		}
	}
}

// MARK: Queryable

extension PrivateFieldProperty: AnyQueryableProperty {
	public var path: [FieldKey] {
		[key]
	}
}

extension PrivateFieldProperty: QueryableProperty {}

// MARK: Query-addressable

extension PrivateFieldProperty: AnyQueryAddressableProperty {
	public var anyQueryableProperty: any AnyQueryableProperty { self }
	public var queryablePath: [FieldKey] { path }
}

extension PrivateFieldProperty: QueryAddressableProperty {
	public var queryableProperty: PrivateFieldProperty<Model, Value> { self }
}

// MARK: Database

extension PrivateFieldProperty: AnyDatabaseProperty {
	public var keys: [FieldKey] {
		[key]
	}

	public func input(to input: any DatabaseInput) {
		if input.wantsUnmodifiedKeys {
			input.set(inputValue ?? outputValue.map { .bind($0) } ?? .default, at: key)
		} else if let inputValue = inputValue {
			input.set(inputValue, at: key)
		}
	}

	public func output(from output: any DatabaseOutput) throws {
		if output.contains(key) {
			inputValue = nil
			do {
				outputValue = try output.decode(key, as: Value.self)
			} catch {
				throw FluentError.invalidField(
					name: key.description,
					valueType: Value.self,
					error: error
				)
			}
		}
	}
}

// MARK: Codable

extension PrivateFieldProperty: AnyCodableProperty {
	public var skipPropertyEncoding: Bool { true }

	public func encode(to _: any Encoder) throws {}
	public func decode(from _: any Decoder) throws {}
}
