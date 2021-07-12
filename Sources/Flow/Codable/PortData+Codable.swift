//
//  PortData+Codable.swift
//  
//
//  Created by nori on 2021/07/10.
//

import Foundation

extension PortData: Codable {

    enum CodingKeys: CodingKey {
        case bool
        case int
        case float
        case string
        case boolArray
        case intArray
        case floatArray
        case stringArray
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
            case .bool(let type):
                let value = try type?.get()
                try container.encode(value, forKey: .bool)
            case .int(let type):
                let value = try type?.get()
                try container.encode(value, forKey: .int)
            case .float(let type):
                let value = try type?.get()
                try container.encode(value, forKey: .float)
            case .string(let type):
                let value = try type?.get()
                try container.encode(value, forKey: .string)
            case .boolArray(let type):
                let value = try type?.get()
                try container.encode(value, forKey: .boolArray)
            case .intArray(let type):
                let value = try type?.get()
                try container.encode(value, forKey: .intArray)
            case .floatArray(let type):
                let value = try type?.get()
                try container.encode(value, forKey: .floatArray)
            case .stringArray(let type):
                let value = try type?.get()
                try container.encode(value, forKey: .stringArray)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = container.allKeys.first
        switch key {
            case .bool:
                let value = try container.decode(Bool?.self, forKey: .bool)
                self = .bool(.success(value))
            case .int:
                let value = try container.decode(Int?.self, forKey: .int)
                self = .int(value)
            case .float:
                let value = try container.decode(Float?.self, forKey: .float)
                self = .float(value)
            case .string:
                let value = try container.decode(String?.self, forKey: .string)
                self = .string(value)
            case .boolArray:
                let value = try container.decode([Bool]?.self, forKey: .boolArray)
                self = .boolArray(value)
            case .intArray:
                let value = try container.decode([Int]?.self, forKey: .intArray)
                self = .intArray(value)
            case .floatArray:
                let value = try container.decode([Float]?.self, forKey: .floatArray)
                self = .floatArray(value)
            case .stringArray:
                let value = try container.decode([String]?.self, forKey: .stringArray)
                self = .stringArray(value)
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

