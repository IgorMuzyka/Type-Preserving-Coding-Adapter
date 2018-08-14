
public enum TypePreservingCodingAdapterError: Error {

	case adapterWasNotProvided
	case noDecodableRegisteredForSignature(Signature)
	case noSignatureRegisteredForAlias(Alias)
	case noAliasRegisteredForSignature(Signature)
}

