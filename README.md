## Type Preserving Coding Adapter

[![Build Status](https://travis-ci.org/IgorMuzyka/Type-Preserving-Coding-Adapter.svg?branch=master)](https://travis-ci.org/IgorMuzyka/Type-Preserving-Coding-Adapter)

Coding Adapter provides you with ***type specific*** *serialization*, so that you can **decode** ***specific subclasses*** where they are *hidden* behind some ***common ancestor*** or hide codable objects behind a ***protocol typed*** *variable*.

> This also works with **Swift** on **linux** (tested).

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

Lets say you want to define **Animal** _Protocol_. (This would also work if **Animal** was a _Class_ and **Dog** and **Cat** would _inherit_ from it).

```swift
public protocol Animal: Codable {   
    func say() -> String
}
```

And then you have a **Dog** and a **Cat** _structs_ which _conform_ to it.

```swift
public struct Dog: Animal, Codable {
    public func say() -> String { return "bark" }
}

public struct Cat: Animal, Codable {
    public func say() -> String { return "meow" }
}
```

And then you have some **Zoo** _struct_ which holds your **animals** as **Animal** and is _codable_. You decide if the **animals** gets _encoded_ by **Alias** or **Signature** by defining **Strategy** when _wrapping_ **animals** in **_encode function_** below.

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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.animals = try container.decode([Wrap].self, forKey: .animals).map { $0.wrapped as! Animal }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(animals.map { Wrap(wrapped: $0, strategy: .alias) }, forKey: .animals)
    }
}
```

To preserve types while _decoding_ and _encoding_ the **Zoo** you'll need to have some _setup_ close to this.

Create an **Adapter**. Set it to _userInfo_ of **Encoder** and **Decoder** you would use. And **register** your **types** and their **aliases** in **Adapter**.

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
After decoding **Cat** and **Dog** _instances_ would be of _correct type_. (behaves the same if **Animal**, **Dog** and **Cat** would be _classes_).

## About

- **Signature** - is a string made from the **Type** itself so it should be consistent throughout the **target** (**target name** is a frontmost prefix part of a **signature**). Will differ between targets. **Signature** for **types** may also differ between some **versions** of **iOS SDK**. Example: `__ObjC.UIView.Type` and `__C.UIView.Type`. That's when you may need **alias**.
- **Alias** - is a way to enable coding when communicating between multiple platforms but still using **Swift**. For example when you have different targets for **iOS**, **macOS** and **Linux** the target name will be a prefix of your type **Signature** so you'll want to use an alias to support the same **struct** or a **class** coding between your **targets**.
- **TypePreservingCodingAdapter** - is an adapter inserted into **Encoder** and/or **Decoder** to help hide your real **classes** or **structs** behind a **base class** or a **protocol** (as shown in example above in a Protocol usage example). You'll want to register your **types** and **aliases** for them with **Adapter** by using `adapter.register(type: MyClass.self)` or `adapter.register(alias: "my_class", for: MyClass.self)`.
- **Wrap** - is a helper which allows seamless usage of a **TypePreservingCodingAdapter** with your **types**. Also **Wrap** allows you to select a _coding_ **strategy** which can be `.signature` or `.alias`. And as show in example you can use **Wrap** to wrap your **types** and be sure their **types** are not missed when you _decoding_.


## Author

Igor Muzyka, igormuzyka42@gmail.com

## License

TypePreservingCodingAdapter is available under the MIT license. See the LICENSE file for more info.
