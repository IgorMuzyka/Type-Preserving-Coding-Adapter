
// MARK: Definition
/// Wrapper for objects which require Type preservation while being encoded/decoded
public struct Wrap {

	/// Strategy Defines if coding will be done by Signature or by its Alias
	public enum Strategy: UInt, Codable {

		case signature, alias
	}

	public typealias Wrapped = Codable

	public let wrapped: Wrapped
	public let strategy: Strategy

	public init(wrapped: Wrapped, strategy: Strategy = .signature) {
		self.wrapped = wrapped
		self.strategy = strategy
	}
}

// MARK: Codable conformance
extension Wrap: Codable {

	private enum CodingKeys: StringLiteralType, CodingKey {

		case strategy = "__type_preserving_strategy"
		case type = "__preserved_type"
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let adapter = try decoder.typePreservingAdapter()
		let strategy = try container.decode(Strategy.self, forKey: .strategy)

		switch strategy {
		case .alias:
			let alias = try container.decode(Alias.self, forKey: .type)
			let decodable = try adapter.metaCodable(for: alias)
			self.wrapped = try decodable.init(from: decoder)
		case .signature:
			let signature = try container.decode(Signature.self, forKey: .type)
			let decodable = try adapter.metaCodable(for: signature)
			self.wrapped = try decodable.init(from: decoder)
		}
		self.strategy = strategy
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		let adapter = try encoder.typePreservingAdapter()
		let signature = Signature(object: wrapped)
		try container.encode(strategy, forKey: .strategy)

		switch strategy {
		case .alias:
			let alias = try adapter.alias(for: signature)
			try container.encode(alias, forKey: .type)
		case .signature:
			try container.encode(signature, forKey: .type)
		}

		try wrapped.encode(to: encoder)
	}
}
