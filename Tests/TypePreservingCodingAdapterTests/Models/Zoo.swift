//
//  Zoo.swift
//  TypePreservingAdapterTests
//
//  Created by Igor Muzyka on 7/21/18.
//  Copyright © 2018 Igor Muzyka. All rights reserved.
//

@testable import TypePreservingCodingAdapter

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
