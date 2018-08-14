
/// Represents a definite Signature for a Type.
/// Example: `Swift.String.Type` for String or it's instance.
public struct Signature: Hashable, Equatable, Codable {

	public let rawValue: String

	public init(type _type: Any.Type) {
		self.rawValue = String(reflecting: type(of: _type))
	}

	public init(object: Any) {
		self.rawValue = String(reflecting: type(of: type(of: object)))
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.rawValue = try container.decode(String.self)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}
}
