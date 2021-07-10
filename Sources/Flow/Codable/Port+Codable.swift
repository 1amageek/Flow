//
//  Port+Codable.swift
//  
//
//  Created by nori on 2021/07/10.
//

import Foundation
import CoreGraphics

extension Port: Codable {

    enum CodingKeys: CodingKey {
        case nodeID
        case type
        case id
        case data
        case name
        case position
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nodeID, forKey: .nodeID)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(data, forKey: .data)
        try container.encode(name, forKey: .name)
        try container.encode(position, forKey: .position)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nodeID = try container.decode(Node.ID.self, forKey: .nodeID)
        type = try container.decode(PortType.self, forKey: .type)
        id = try container.decode(Int.self, forKey: .id)
        data = try container.decode(PortData.self, forKey: .data)
        name = try container.decode(String?.self, forKey: .name)
        position = try container.decode(CGPoint.self, forKey: .position)
    }

}
