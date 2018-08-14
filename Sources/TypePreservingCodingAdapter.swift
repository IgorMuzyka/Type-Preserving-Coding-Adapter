
// MARK: Definition
/// Type Preserving Coding Adapter for type preserving encoding/decoding of objects which otherwise would require lots of boilerplate Codable conformance code.
open class TypePreservingCodingAdapter {

	/// A typealias covering Codable.Type behind a more domain specific name
	public typealias MetaCodable = Codable.Type

	private var metaCodablesBySignature = [Signature: MetaCodable]()
	private var signaturesByAliases = [Alias: Signature]()
	private var aliasesBySignatures = [Signature: Alias]()

	public init() {}
}

// MARK: Registration
extension TypePreservingCodingAdapter {

	/// Registers Type T.Type for it's Signature.
	@discardableResult
	public func register<T: Codable>(type: T.Type) -> TypePreservingCodingAdapter {
		metaCodablesBySignature[Signature(type: type)] = type

		return self
	}

	/// Registers Alias for Signature of Type T.Type and vice versa.
	@discardableResult
	public func register<T: Codable>(alias: Alias, for type: T.Type) -> TypePreservingCodingAdapter {
		let signature = Signature(type: type)

		signaturesByAliases[alias] = signature
		aliasesBySignatures[signature] = alias

		return self
	}
}

// MARK: Accessing
extension TypePreservingCodingAdapter {

	/// Provides MetaCodable registered for Signature if it is registered, otherwise throws an error.
	public func metaCodable(for signature: Signature) throws -> MetaCodable {
		guard let decodable = metaCodablesBySignature[signature] else {
			throw TypePreservingCodingAdapterError.noDecodableRegisteredForSignature(signature)
		}

		return decodable
	}

	/// Provides MetaCodable registered for Alias if it is registered, otherwise throws an error.
	public func metaCodable(for alias: Alias) throws -> MetaCodable {
		guard let signature = signaturesByAliases[alias] else {
			throw TypePreservingCodingAdapterError.noSignatureRegisteredForAlias(alias)
		}

		return try metaCodable(for: signature)
	}
}

// MARK: Convenience
extension TypePreservingCodingAdapter {

	/// Provides Alias registered for Signature if it is registered, otherwise throws an error.
	internal func alias(for signature: Signature) throws -> Alias {
		guard let alias = aliasesBySignatures[signature] else {
			throw TypePreservingCodingAdapterError.noAliasRegisteredForSignature(signature)
		}

		return alias
	}
}
