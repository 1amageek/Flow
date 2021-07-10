//
//  Edge+Codable.swift
//  
//
//  Created by nori on 2021/07/10.
//

import Foundation

extension Edge: Codable {

    enum CodingKeys: CodingKey {
        case id
        case source
        case target
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(source, forKey: .source)
        try container.encode(target, forKey: .target)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        source = try container.decode(Address.self, forKey: .source)
        target = try container.decode(Address.self, forKey: .target)
    }
}
