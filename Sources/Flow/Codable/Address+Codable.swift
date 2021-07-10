//
//  Address+Codable.swift
//  
//
//  Created by nori on 2021/07/10.
//

import Foundation

extension Address.Port: Codable {
    
    enum CodingKeys: CodingKey {
        case input
        case output
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
            case .input(let index):
                try container.encode(index, forKey: .input)
            case .output(let index):
                try container.encode(index, forKey: .output)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        switch key {
            case .input:
                let value = try container.decode(PortIndex.self, forKey: .input)
                self = .input(value)
            case .output:
                let value = try container.decode(PortIndex.self, forKey: .output)
                self = .output(value)
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

extension Address: Codable {
    
    enum CodingKeys: CodingKey {
        case id
        case port
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(port, forKey: .port)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        port = try container.decode(Port.self, forKey: .port)
    }
}
