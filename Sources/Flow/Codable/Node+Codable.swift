//
//  Node+Codable.swift
//  
//
//  Created by nori on 2021/07/10.
//

import Foundation
import CoreGraphics

extension NodeType: Codable {

    enum CodingKeys: CodingKey {
        case input
        case output
        case io
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
            case .input(let type):
                try container.encode(type, forKey: .input)
            case .output(let type):
                try container.encode(type, forKey: .output)
            case .io(let type):
                try container.encode(type, forKey: .io)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        switch key {
            case .input:
                let id = try container.decode(Callable.ID.self, forKey: .input)
                self = .input(id)
            case .output:
                let id = try container.decode(Callable.ID.self, forKey: .output)
                self = .output(id)
            case .io:
                let id = try container.decode(Callable.ID.self, forKey: .io)
                self = .io(id)
            default:
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Unabled to decode enum."
                    )
                )
        }
    }
}

extension Node: Codable {

    enum CodingKeys: CodingKey {
        case type
        case id
        case name
        case position
        case inputs
        case outputs
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(position, forKey: .position)
        try container.encode(inputs, forKey: .inputs)
        try container.encode(outputs, forKey: .outputs)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(NodeType.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        position = try container.decode(CGPoint.self, forKey: .position)
        inputs = try container.decode([Port].self, forKey: .inputs)
        outputs = try container.decode([Port].self, forKey: .outputs)
    }
}
