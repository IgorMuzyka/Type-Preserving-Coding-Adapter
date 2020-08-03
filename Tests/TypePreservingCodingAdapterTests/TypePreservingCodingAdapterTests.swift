
import XCTest
import Foundation
import TypePreservingCodingAdapter

final class TypePreservingCodingAdapterTests: XCTestCase {

    private let adapter = TypePreservingCodingAdapter()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let unsetupEncoder = JSONEncoder()
    private let unsetupDecoder = JSONDecoder()
    private let codable = ConvenienceTestCodable(name: "Convenience codable")
    private let signatures = [
        Signature(object: Int(0)),
        Signature(type: Int.self),
        Signature(object: String()),
        Signature(type: String.self),
        Signature(object: Array<Int>()),
        Signature(type: Array<Int>.self),
        Signature(object: Dictionary<String, Int>()),
        Signature(type: Dictionary<String, Int>.self)
    ]
    private let aliases: [Alias] = [
        "Dog",
        "Cat",
        "Zoo",
        Alias("Some alias"),
        Alias("Another alias")
    ]

    override func setUp() {
        encoder.userInfo[.typePreservingAdapter] = adapter
        decoder.userInfo[.typePreservingAdapter] = adapter

        adapter
            .register(type: Cat.self).register(alias: "dog", for: Dog.self)
            .register(type: Dog.self).register(alias: "cat", for: Cat.self)
    }

    func testDecodedDataConsistency() {
        let zoo = Zoo(animals: [Cat(), Dog(), Cat(), Dog()])

        let data = try! encoder.encode(zoo)
        let decodedZoo = try! decoder.decode(Zoo.self, from: data)

        XCTAssertEqual(zoo.animals.map { $0.say() }, decodedZoo.animals.map { $0.say() })
    }

    // MARK: Signature
    // MARK: Consistency tests for Instances and their expected Signtaure.rawValue

    func testIntInstanceSignature() {
        XCTAssertEqual(Signature(object: Int(0)).rawValue, "Swift.Int.Type")
    }

    func testStringInstanceSignature() {
        XCTAssertEqual(Signature(object: String()).rawValue, "Swift.String.Type")
    }

    func testArrayInstanceSignature() {
        XCTAssertEqual(Signature(object: Array<Int>()).rawValue, "Swift.Array<Swift.Int>.Type")
    }

    func testDictionaryInstanceSignature() {
        XCTAssertEqual(Signature(object: Dictionary<String, Int>()).rawValue, "Swift.Dictionary<Swift.String, Swift.Int>.Type")
    }

    func testClassInstanceSignature() {
        XCTAssertEqual(Signature(object: ExampleClass()).rawValue, "TypePreservingCodingAdapterTests.ExampleClass.Type")
    }

    func testDerivativeClassInstanceSingature() {
        XCTAssertEqual(Signature(object: ExampleDerivativeClass()).rawValue, "TypePreservingCodingAdapterTests.ExampleDerivativeClass.Type")
    }

    func testNestedClassInstanceSignature() {
        XCTAssertEqual(Signature(object: ExampleClass.NestedClass()).rawValue, "TypePreservingCodingAdapterTests.ExampleClass.NestedClass.Type")
    }

    func testNestedStructInstanceSignature() {
        XCTAssertEqual(Signature(object: ExampleClass.NestedStruct()).rawValue, "TypePreservingCodingAdapterTests.ExampleClass.NestedStruct.Type")
    }

    func testNestedEnumInstanceSignature() {
        XCTAssertEqual(Signature(object: ExampleClass.NestedEnum.exampleCase).rawValue, "TypePreservingCodingAdapterTests.ExampleClass.NestedEnum.Type")
    }

    // MARK: Consistency tests for Types and their expected Signtaure.rawValue

    func testIntTypeSignature() {
        XCTAssertEqual(Signature(type: Int.self).rawValue, "Swift.Int.Type")
    }

    func testStringTypeSignature() {
        XCTAssertEqual(Signature(type: String.self).rawValue, "Swift.String.Type")
    }

    func testArrayTypeSignature() {
        XCTAssertEqual(Signature(type: Array<Int>.self).rawValue, "Swift.Array<Swift.Int>.Type")
    }

    func testDictionaryTypeSignature() {
        XCTAssertEqual(Signature(type: Dictionary<String, Int>.self).rawValue, "Swift.Dictionary<Swift.String, Swift.Int>.Type")
    }

    func testClassTypeSignature() {
        XCTAssertEqual(Signature(type: ExampleClass.self).rawValue, "TypePreservingCodingAdapterTests.ExampleClass.Type")
    }

    func testDerivativeClassTypeSignature() {
        XCTAssertEqual(Signature(type: ExampleDerivativeClass.self).rawValue, "TypePreservingCodingAdapterTests.ExampleDerivativeClass.Type")
    }

    func testNestedClassTypeSignature() {
        XCTAssertEqual(Signature(type: ExampleClass.NestedClass.self).rawValue, "TypePreservingCodingAdapterTests.ExampleClass.NestedClass.Type")
    }

    func testNestedEnumTypeSignature() {
        XCTAssertEqual(Signature(type: ExampleClass.NestedStruct.self).rawValue, "TypePreservingCodingAdapterTests.ExampleClass.NestedStruct.Type")
    }

    func testNestedStructTypeSignature() {
        XCTAssertEqual(Signature(type: ExampleClass.NestedEnum.self).rawValue, "TypePreservingCodingAdapterTests.ExampleClass.NestedEnum.Type")
    }

    // MARK: Consistency tests for Signature of Type and it's Instance

    func testStringSignatureSignature() {
        XCTAssertEqual(Signature(type: String.self), Signature(object: String()))
    }

    func testIntSignatureConsistency() {
        XCTAssertEqual(Signature(type: Int.self), Signature(object: Int(0)))
    }

    func testArraySignatureConsistency() {
        XCTAssertEqual(Signature(type: Array<Int>.self), Signature(object: Array<Int>()))
    }

    func testDictionarySignatureConsistency() {
        XCTAssertEqual(Signature(type: Dictionary<String, Int>.self), Signature(object: Dictionary<String,Int>()))
    }

    func testClassSignatureConsistency() {
        XCTAssertEqual(Signature(type: ExampleClass.self), Signature(object: ExampleClass()))
    }

    func testDerivativeClassSignatureConsistency() {
        XCTAssertEqual(Signature(type: ExampleDerivativeClass.self), Signature(object: ExampleDerivativeClass()))
    }

    func testNestedClassSignatureConsistency() {
        XCTAssertEqual(Signature(type: ExampleClass.NestedClass.self), Signature(object: ExampleClass.NestedClass()))
    }

    func testNestedEnumSignatureConsistency() {
        XCTAssertEqual(Signature(type: ExampleClass.NestedStruct.self), Signature(object: ExampleClass.NestedStruct()))
    }

    func testNestedStructSignatureConsistency() {
        XCTAssertEqual(Signature(type: ExampleClass.NestedEnum.self), Signature(object: ExampleClass.NestedEnum.exampleCase))
    }

    // MARK: Coding tests

    func testSignatureEncoding() {
        XCTAssertNoThrow(try encoder.encode(signatures))
    }

    func testSignatureDecoding() throws {
        let data = try encoder.encode(signatures)
        XCTAssertNoThrow(try decoder.decode(Array<Signature>.self, from: data))
    }

    func testSignatureCodingConsistency() throws {
        let data = try encoder.encode(signatures)
        let decodedSignatures = try decoder.decode(Array<Signature>.self, from: data)

        XCTAssertEqual(signatures, decodedSignatures)
    }

    // MARK: Alias

    func testAliasInit() {
        XCTAssertEqual(Alias("Alias"), Alias(stringLiteral: "Alias"))
        XCTAssertEqual(Alias("Alias"), Alias(extendedGraphemeClusterLiteral: "Alias"))
        XCTAssertEqual(Alias("Alias"), Alias(unicodeScalarLiteral: "Alias"))
        XCTAssertEqual(Alias("Alias").rawValue, "Alias")
    }

    // MARK: Coding tests

    func testAliasEncoding() {
        XCTAssertNoThrow(try encoder.encode(aliases))
    }

    func testAliasDecoding() throws {
        let data = try encoder.encode(aliases)
        XCTAssertNoThrow(try decoder.decode(Array<Alias>.self, from: data))
    }

    func testAliasCodingConsistency() throws {
        let data = try encoder.encode(aliases)
        let decodedAliases = try decoder.decode(Array<Alias>.self, from: data)

        XCTAssertEqual(aliases, decodedAliases)
    }

    // MARK: Convenience

    func testConvenienceFailingEncoding() {
        XCTAssertThrowsError(try unsetupEncoder.encode(codable))
    }

    func testConvenienceEncoding() {
        XCTAssertNoThrow(try encoder.encode(codable))
    }

    func testConvenienceFailingDecoding() throws {
        let data = try encoder.encode(codable)
        XCTAssertThrowsError(try unsetupDecoder.decode(ConvenienceTestCodable.self, from: data))
    }

    func testConvenienceDecoding() throws {
        let data = try encoder.encode(codable)
        XCTAssertNoThrow(try decoder.decode(ConvenienceTestCodable.self, from: data))
    }

    static var allTests = [
        ("testDecodedDataConsistency", testDecodedDataConsistency),
        ("testIntInstanceSignature", testIntInstanceSignature),
        ("testStringInstanceSignature", testStringInstanceSignature),
        ("testArrayInstanceSignature", testArrayInstanceSignature),
        ("testDictionaryInstanceSignature", testDictionaryInstanceSignature),
        ("testClassInstanceSignature", testClassInstanceSignature),
        ("testDerivativeClassInstanceSingature", testDerivativeClassInstanceSingature),
        ("testNestedClassInstanceSignature", testNestedClassInstanceSignature),
        ("testNestedStructInstanceSignature", testNestedStructInstanceSignature),
        ("testNestedEnumInstanceSignature", testNestedEnumInstanceSignature),
        ("testIntTypeSignature", testIntTypeSignature),
        ("testStringTypeSignature", testStringTypeSignature),
        ("testArrayTypeSignature", testArrayTypeSignature),
        ("testDictionaryTypeSignature", testDictionaryTypeSignature),
        ("testClassTypeSignature", testClassTypeSignature),
        ("testDerivativeClassTypeSignature", testDerivativeClassTypeSignature),
        ("testNestedClassTypeSignature", testNestedClassTypeSignature),
        ("testNestedEnumTypeSignature", testNestedEnumTypeSignature),
        ("testNestedStructTypeSignature", testNestedStructTypeSignature),
        ("testStringSignatureSignature", testStringSignatureSignature),
        ("testIntSignatureConsistency", testIntSignatureConsistency),
        ("testArraySignatureConsistency", testArraySignatureConsistency),
        ("testDictionarySignatureConsistency", testDictionarySignatureConsistency),
        ("testClassSignatureConsistency", testClassSignatureConsistency),
        ("testDerivativeClassSignatureConsistency", testDerivativeClassSignatureConsistency),
        ("testNestedClassSignatureConsistency", testNestedClassSignatureConsistency),
        ("testNestedEnumSignatureConsistency", testNestedEnumSignatureConsistency),
        ("testNestedStructSignatureConsistency", testNestedStructSignatureConsistency),
        ("testEncoding", testSignatureEncoding),
        ("testDecoding", testSignatureDecoding),
        ("testCodingConsistency", testSignatureCodingConsistency),
        ("testAliasInit", testAliasInit),
        ("testAliasEncoding", testAliasEncoding),
        ("testAliasDecoding", testAliasDecoding),
        ("testAliasCodingConsistency", testAliasCodingConsistency),
        ("testConvenienceFailingEncoding", testConvenienceFailingEncoding),
        ("testConvenienceEncoding", testConvenienceEncoding),
        ("testConvenienceFailingDecoding", testConvenienceFailingDecoding),
        ("testConvenienceDecoding", testConvenienceDecoding),
        ]

}


internal class ExampleClass {

    internal class NestedClass {}
    internal struct NestedStruct {}
    internal enum NestedEnum {

        case exampleCase
    }
}

internal class ExampleDerivativeClass: ExampleClass {}


internal struct ConvenienceTestCodable: Codable {

    let name: String

    init(name: String) {
        self.name = name
    }

    private enum CodingKeys: CodingKey {

        case name
    }

    init(from decoder: Decoder) throws {
        _ = try decoder.typePreservingAdapter()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        _ = try encoder.typePreservingAdapter()
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}
