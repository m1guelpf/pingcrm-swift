struct EncodableDictionary: Encodable {
	let dictionary: [String: Encodable]

	init(_ dictionary: [String: Encodable]) {
		self.dictionary = dictionary
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: DynamicKey.self)
		for (key, value) in dictionary {
			try container.encode(value, forKey: DynamicKey(key))
		}
	}

	private struct DynamicKey: CodingKey {
		let stringValue: String

		init(_ name: String) {
			stringValue = name
		}

		init?(stringValue: String) {
			self.stringValue = stringValue
		}

		init?(intValue _: Int) {
			return nil
		}

		var intValue: Int? {
			return nil
		}
	}
}
