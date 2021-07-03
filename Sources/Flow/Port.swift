//
//  Port.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation
import CoreGraphics

public enum PortType {
    case input
    case output
}

public struct Port: Identifiable, GeometryProperties {

    public var node: Node

    public var type: PortType

    public var id: Int

    public var data: PortData

    public var title: String?

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    init(type: PortType, id: Int, data: PortData, title: String? = nil, node: Node) {
        self.type = type
        self.id = id
        self.data = data
        self.title = title
        self.node = node
    }

    static func input(id: Int, data: PortData, title: String? = nil, node: Node) -> Port {
        Port(type: .input, id: id, data: data, title: title, node: node)
    }

    static func output(id: Int, data: PortData, title: String? = nil, node: Node) -> Port {
        Port(type: .output, id: id, data: data, title: title, node: node)
    }
}

extension Port {

    public var address: Address {
        switch type {
            case .input: return .input(node.id, index: id)
            case .output: return .output(node.id, index: id)
        }
    }
}

public struct Interface {

    public var title: String?

    public var data: PortData

    public init(_ data: PortData, title: String? = nil) {
        self.data = data
        self.title = title
    }

    public static func bool(_ value: Bool? = nil, title: String? = nil) -> Interface { Interface(.bool(value), title: title) }

    public static func int(_ value: Int? = nil, title: String? = nil) -> Interface { Interface(.int(value), title: title) }

    public static func float(_ value: Float? = nil, title: String? = nil) -> Interface { Interface(.float(value), title: title) }

    public static func string(_ value: String? = nil, title: String? = nil) -> Interface { Interface(.string(value), title: title) }
}

//@resultBuilder
//public struct InterfaceBuilder {
//
//    public static func buildBlock() -> [Port] {
//        return []
//    }
//
//    public static func buildBlock(_ interface: Interface) -> [Port] {
//        return [interface].enumerated().map { Port(id: $0, title: $1.title) }
//    }
//
//    public static func buildBlock(_ c0: Interface<C0>, _ c1: Interface<C1>) -> Interface<(C0, C1)> {
//        return Interface((c0.value, c1.value))
//    }
//
//    public static func buildBlock<C0, C1, C2>(_ c0: Interface<C0>, _ c1: Interface<C1>, _ c2: Interface<C2>) -> Interface<(C0, C1, C2)> {
//        return Interface((c0.value, c1.value, c2.value))
//    }
//
//    public static func buildBlock<C0, C1, C2, C3>(_ c0: Interface<C0>, _ c1: Interface<C1>, _ c2: Interface<C2>, _ c3: Interface<C3>) -> Interface<(C0, C1, C2, C3)> {
//        return Interface((c0.value, c1.value, c2.value, c3.value))
//    }
//}

//@resultBuilder
//public struct InterfaceBuilder {
//
//    public static func buildBlock() -> Interface<()> {
//        return Interface(())
//    }
//
//    public static func buildBlock<Content>(_ content: Interface<Content>) -> Interface<Content> {
//        return Interface(content.value)
//    }
//
//    public static func buildBlock<C0, C1>(_ c0: Interface<C0>, _ c1: Interface<C1>) -> Interface<(C0, C1)> {
//        return Interface((c0.value, c1.value))
//    }
//
//    public static func buildBlock<C0, C1, C2>(_ c0: Interface<C0>, _ c1: Interface<C1>, _ c2: Interface<C2>) -> Interface<(C0, C1, C2)> {
//        return Interface((c0.value, c1.value, c2.value))
//    }
//
//    public static func buildBlock<C0, C1, C2, C3>(_ c0: Interface<C0>, _ c1: Interface<C1>, _ c2: Interface<C2>, _ c3: Interface<C3>) -> Interface<(C0, C1, C2, C3)> {
//        return Interface((c0.value, c1.value, c2.value, c3.value))
//    }
//}

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
            }
        }
    }
}
