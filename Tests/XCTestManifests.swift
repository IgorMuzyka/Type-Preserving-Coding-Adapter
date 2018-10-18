import XCTest

extension TypePreservingCodingAdapterTests {
    static let __allTests = [
        ("testAliasCodingConsistency", testAliasCodingConsistency),
        ("testAliasDecoding", testAliasDecoding),
        ("testAliasEncoding", testAliasEncoding),
        ("testAliasInit", testAliasInit),
        ("testArrayInstanceSignature", testArrayInstanceSignature),
        ("testArraySignatureConsistency", testArraySignatureConsistency),
        ("testArrayTypeSignature", testArrayTypeSignature),
        ("testClassInstanceSignature", testClassInstanceSignature),
        ("testClassSignatureConsistency", testClassSignatureConsistency),
        ("testClassTypeSignature", testClassTypeSignature),
        ("testConvenienceDecoding", testConvenienceDecoding),
        ("testConvenienceEncoding", testConvenienceEncoding),
        ("testConvenienceFailingDecoding", testConvenienceFailingDecoding),
        ("testConvenienceFailingEncoding", testConvenienceFailingEncoding),
        ("testDecodedDataConsistency", testDecodedDataConsistency),
        ("testDerivativeClassInstanceSingature", testDerivativeClassInstanceSingature),
        ("testDerivativeClassSignatureConsistency", testDerivativeClassSignatureConsistency),
        ("testDerivativeClassTypeSignature", testDerivativeClassTypeSignature),
        ("testDictionaryInstanceSignature", testDictionaryInstanceSignature),
        ("testDictionarySignatureConsistency", testDictionarySignatureConsistency),
        ("testDictionaryTypeSignature", testDictionaryTypeSignature),
        ("testIntInstanceSignature", testIntInstanceSignature),
        ("testIntSignatureConsistency", testIntSignatureConsistency),
        ("testIntTypeSignature", testIntTypeSignature),
        ("testNestedClassInstanceSignature", testNestedClassInstanceSignature),
        ("testNestedClassSignatureConsistency", testNestedClassSignatureConsistency),
        ("testNestedClassTypeSignature", testNestedClassTypeSignature),
        ("testNestedEnumInstanceSignature", testNestedEnumInstanceSignature),
        ("testNestedEnumSignatureConsistency", testNestedEnumSignatureConsistency),
        ("testNestedEnumTypeSignature", testNestedEnumTypeSignature),
        ("testNestedStructInstanceSignature", testNestedStructInstanceSignature),
        ("testNestedStructSignatureConsistency", testNestedStructSignatureConsistency),
        ("testNestedStructTypeSignature", testNestedStructTypeSignature),
        ("testSignatureCodingConsistency", testSignatureCodingConsistency),
        ("testSignatureDecoding", testSignatureDecoding),
        ("testSignatureEncoding", testSignatureEncoding),
        ("testStringInstanceSignature", testStringInstanceSignature),
        ("testStringSignatureSignature", testStringSignatureSignature),
        ("testStringTypeSignature", testStringTypeSignature),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TypePreservingCodingAdapterTests.__allTests),
    ]
}
#endif
