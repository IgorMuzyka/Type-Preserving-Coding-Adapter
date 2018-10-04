//
//  Animal.swift
//  TypePreservingAdapterTests
//
//  Created by Igor Muzyka on 7/21/18.
//  Copyright © 2018 Igor Muzyka. All rights reserved.
//

public protocol Animal: Codable {

    func say() -> String
}

public class Mammal: Animal, Codable {

    public func say() -> String {
        return "__"
    }
}
