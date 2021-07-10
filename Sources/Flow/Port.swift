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

public struct Port: Identifiable, GeometryProperties {

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

    public static func boolArray(_ value: [Bool] = [], name: String? = nil) -> Interface { Interface(.boolArray(value), name: name) }

    public static func intArray(_ value: [Int] = [], name: String? = nil) -> Interface { Interface(.intArray(value), name: name) }

    public static func floatArray(_ value: [Float] = [], name: String? = nil) -> Interface { Interface(.floatArray(value), name: name) }

    public static func stringArray(_ value: [String] = [], name: String? = nil) -> Interface { Interface(.stringArray(value), name: name) }
}

extension Port {

    public var text: String {
        get { self.data.text }
        set {
            switch self.data {
                case .bool(_):
                    if newValue == "true" {
                        self.data = .bool(true)
                        return
                    }
                    if newValue == "false" {
                        self.data = .bool(false)
                        return
                    }
                case .int(_):
                    guard let value = Int(newValue) else { return }
                    self.data = .int(value)
                case .float(_):
                    guard let value = Float(newValue) else { return }
                    self.data = .float(value)
                case .string(_):
                    return self.data = .string(newValue)
                default: fatalError()
            }
        }
    }
}
