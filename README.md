## Type Preserving Coding Adapter

Coding Adapter provides you with ***type specific*** *serialization*, so that you can **decode** ***specific subclasses*** where they are *hidden* behind some ***common ancestor*** or hide codable objects behind a ***protocol typed*** *variable*.

> This should probaly also work with **Swift** on **linux**, but i have not tested it yet.

## Installation

### Swift Package Manager

Add this line to your `Package.swift` dependencies

```swift
.package(url: "https://github.com/IgorMuzyka/Type-Preserving-Coding-Adapter", .branch("master"))
```

### Cocoapods

```ruby
pod 'TypePreservingCodingAdapter', :git => 'https://github.com/IgorMuzyka/Type-Preserving-Coding-Adapter.git'
```

## Protocol usage example

Lets say you want to define Animal Protocol.

```swift
public protocol Animal: Codable {   
    func say() -> String
}
```

And then you have a Dog and a Cat structs which conform to it.

```swift
public struct Dog: Animal, Codable {
    public func say() -> String { return "bark" }
}

public struct Cat: Animal, Codable {
    public func say() -> String { return "meow" }
}
```

And then you have some Zoo struct which holds your animals as Animal and is codable. You decide if the animals gets encoded by Alias or Signature by defining strategy when wrapping animals in encode function below.

```swift
public struct Zoo: Codable {
    
    private enum CodingKeys: CodingKey {
        case animals
    }
    
    public let animals: [Animal]
    
    public init(animals: [Animal]) {
        self.animals = animals
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.ontainer(keyedBy: CodingKeys.self)
        let wraps = try container.decode([Wrap].self, forKey: .animals)
        self.animals = wraps.map { $0.wrapped as! Animal }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let wraps = animals.map { Wrap(wrapped: $0, strategy: .alias) }
        try container.encode(wraps, forKey: .animals)
    }
}
```

To preserve types while decoding and encoding the zoo you'll need to have some setup close to this.

Create an Adapter. Set it to user info of encoder and decoder you would use. And register your types and their aliases in adapter.

```swift
let adapter = TypePreservingCodingAdapter()
let encoder = JSONEncoder()
let decoder = JSONDecoder()

encoder.userInfo[.typePreservingAdapter] = adapter
decoder.userInfo[.typePreservingAdapter] = adapter

adapter
	.register(type: Cat.self)
	.register(alias: "cat", for: Cat.self)
	.register(type: Dog.self)
	.register(alias: "dog", for: Dog.self)

let zoo = Zoo(animals: [Cat(), Dog(), Cat(), Dog()])
let data = try! encoder.encode(zoo)
let decodedZoo = try! decoder.decode(Zoo.self, from: data)
```

## Author

Igor Muzyka, igormuzyka42@gmail.com

## License

TypePreservingCodingAdapter is available under the MIT license. See the LICENSE file for more info.