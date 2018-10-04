
/// Represents an alias supplied by user
public struct Alias: Hashable, Equatable, Codable, ExpressibleByStringLiteral {

	public let rawValue: String

	public init(_ rawValue: String) {
		self.rawValue = rawValue
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.rawValue = try container.decode(String.self)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}

    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}
