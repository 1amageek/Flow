//
//  Port.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation
import CoreGraphics

public enum PortType: String, Codable {
    case input
    case output
}

public struct Port: Identifiable, Hashable, GeometryProperties {

    public static func == (lhs: Port, rhs: Port) -> Bool { lhs.hashValue == rhs.hashValue }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(nodeID)
        hasher.combine(type)
        hasher.combine(id)
        hasher.combine(data)
    }

    public var nodeID: Node.ID

    public var type: PortType

    public var id: Int

    public var data: PortData

    public var name: String?

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    init(type: PortType, id: Int, data: PortData, name: String? = nil, nodeID: Node.ID) {
        self.type = type
        self.id = id
        self.data = data
        self.name = name
        self.nodeID = nodeID
    }

    public mutating func set(_ position: CGPoint) -> Self {
        self.position = position
        return self
    }

    public mutating func set(_ data: PortData) -> Self {
        self.data = data
        return self
    }

    static func input(id: Int, data: PortData, name: String? = nil, nodeID: Node.ID) -> Port {
        Port(type: .input, id: id, data: data, name: name, nodeID: nodeID)
    }

    static func output(id: Int, data: PortData, name: String? = nil, nodeID: Node.ID) -> Port {
        Port(type: .output, id: id, data: data, name: name, nodeID: nodeID)
    }
}

extension Port {

    public var address: Address {
        switch type {
            case .input: return .input(nodeID, index: id)
            case .output: return .output(nodeID, index: id)
        }
    }
}

public struct Interface {

    public var name: String?

    public var data: PortData

    public init(_ data: PortData, name: String? = nil) {
        self.data = data
        self.name = name
    }

    public static func bool(_ value: Bool? = nil, name: String? = nil) -> Interface { Interface(.bool(value), name: name) }

    public static func int(_ value: Int? = nil, name: String? = nil) -> Interface { Interface(.int(value), name: name) }

    public static func float(_ value: Float? = nil, name: String? = nil) -> Interface { Interface(.float(value), name: name) }

    public static func string(_ value: String? = nil, name: String? = nil) -> Interface { Interface(.string(value), name: name) }

    public static func boolArray(_ value: [Bool]? = nil, name: String? = nil) -> Interface { Interface(.boolArray(value), name: name) }

    public static func intArray(_ value: [Int]? = nil, name: String? = nil) -> Interface { Interface(.intArray(value), name: name) }

    public static func floatArray(_ value: [Float]? = nil, name: String? = nil) -> Interface { Interface(.floatArray(value), name: name) }

    public static func stringArray(_ value: [String]? = nil, name: String? = nil) -> Interface { Interface(.stringArray(value), name: name) }
}

extension Port {

    public var intValue: Int? {
        get { self.data.intValue }
        set {

            switch self.data {
                case .bool(_):
                    if newValue == 1 {
                        self.data = .bool(true)
                        return
                    }
                    if newValue == 0 {
                        self.data = .bool(false)
                        return
                    }
                    self.data = .bool(.success(nil))
                case .int(_):
                    self.data = .int(newValue)
                case .float(_):
                    if let value = newValue {
                        self.data = .float(Float(value))
                    } else {
                        self.data = .float(.success(nil))
                    }
                case .string(_):
                    if let value = newValue {
                        self.data = .string(String(value))
                    } else {
                        self.data = .string(.success(nil))
                    }
                default: fatalError()
            }
        }
    }

    public var floatValue: Float? {
        get { self.data.floatValue }
        set {

            switch self.data {
                case .bool(_):
                    if newValue == 1 {
                        self.data = .bool(true)
                        return
                    }
                    if newValue == 0 {
                        self.data = .bool(false)
                        return
                    }
                    self.data = .bool(.success(nil))
                case .int(_):
                    if let value = newValue {
                        self.data = .int(Int(value))
                    } else {
                        self.data = .int(.success(nil))
                    }
                case .float(_):
                    self.data = .float(newValue)
                case .string(_):
                    if let value = newValue {
                        self.data = .string(String(value))
                    } else {
                        self.data = .string(.success(nil))
                    }
                default: fatalError()
            }
        }
    }

    public var stringValue: String? {
        get { self.data.stringValue }
        set {

            switch self.data {
                case .bool(_):
                    if newValue == "true" || newValue == "TRUE" {
                        self.data = .bool(true)
                        return
                    }
                    if newValue == "false" || newValue == "FALSE" {
                        self.data = .bool(false)
                        return
                    }
                    self.data = .bool(.success(nil))
                case .int(_):
                    if let value = newValue {
                        self.data = .int(Int(value))
                    } else {
                        self.data = .int(.success(nil))
                    }
                case .float(_):
                    if let value = newValue {
                        self.data = .float(Float(value))
                    } else {
                        self.data = .float(.success(nil))
                    }
                case .string(_):
                    self.data = .string(newValue)
                default: fatalError()
            }
        }
    }
}

extension Array where Element == Port {

    public func exist(_ id: PortIndex) -> Bool { self.contains(where: { $0.id == id }) }
}
