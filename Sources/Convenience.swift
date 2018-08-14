
extension TypePreservingCodingAdapter {

	internal static var codingUserInfoKey: String = Signature(type: TypePreservingCodingAdapter.self).rawValue
}

extension CodingUserInfoKey {

	public static var typePreservingAdapter: CodingUserInfoKey {
		return CodingUserInfoKey(rawValue: TypePreservingCodingAdapter.codingUserInfoKey)!
	}
}

extension Decoder {

	public func typePreservingAdapter() throws -> TypePreservingCodingAdapter {
		guard let adapter = userInfo[.typePreservingAdapter] as? TypePreservingCodingAdapter else {
			throw TypePreservingCodingAdapterError.adapterWasNotProvided
		}

		return adapter
	}
}

extension Encoder {

	public func typePreservingAdapter() throws -> TypePreservingCodingAdapter {
		guard let adapter = userInfo[.typePreservingAdapter] as? TypePreservingCodingAdapter else {
			throw TypePreservingCodingAdapterError.adapterWasNotProvided
		}

		return adapter
	}
}
