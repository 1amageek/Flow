//
//  Port.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation
import CoreGraphics

//public protocol Connectable {
//
//    associatedtype Value
//
//    var value: Value { get }
//}
//
//public struct Interface<T>: Connectable {
//
//    public typealias Value = T
//
//    public var value: T
//
//    public init(_ value: Value) {
//        self.value = value
//    }
//}

public struct Port: Identifiable, GeometryProperties {

    public var id: Int

    public var title: String?

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public init(id: Int, title: String? = nil) {
        self.id = id
        self.title = title
    }
}

public struct Interface {

    public var title: String?

    public init(title: String? = nil) {
        self.title = title
    }
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

//
//
//public struct PortItem: Identifiable, GeomertryProperties {
//
//    public var type: PortType
//
//    public var id: String
//
//    public var title: String
//
//    public var data: PortData?
//
//    public var position: CGPoint = .zero
//
//    public var offset: CGSize = .zero
//
//    public var size: CGSize = .zero
//
//    init(type: PortType, id: String, title: String, data: PortData? = nil) {
//        self.type = type
//        self.id = id
//        self.title = title
//        self.data = data
//    }
//
//    public static func input(id: String, title: String, data: PortData? = nil) -> Port { Port(type: .input, id: id, title: title, data: data) }
//
//    public static func output(id: String, title: String, data: PortData? = nil) -> Port { Port(type: .output, id: id, title: title, data: data) }
//
//    public var text: String {
//        get {
//            guard let data = data else { return "" }
//            switch data {
//                case .none: return ""
//                case .int(let value): return "\(value)"
//                case .float(let value): return "\(value)"
//                case .string(let value): return value
//            }
//        }
//        set {
//            guard let data = data else {
//                self.data = .string(newValue)
//                return
//            }
//            switch data {
//                case .none: self.data = PortData.none
//                case .int(_): self.data = .int(Int(newValue) ?? 0)
//                case .float(_): self.data = .float(Float(newValue) ?? 0)
//                case .string(_): self.data = .string(newValue)
//            }
//        }
//    }
//}
//
//public extension Port {
//
//    var intValue: Int {
//        get {
//            if case .int(let value) = self.data {
//                return value
//            }
//            fatalError()
//        }
//        set {
//            self.data = .int(newValue)
//        }
//    }
//
//    var floatValue: Float {
//        get {
//            if case .float(let value) = self.data {
//                return value
//            }
//            fatalError()
//        }
//        set {
//            self.data = .float(newValue)
//        }
//    }
//
//    var stringValue: String {
//        get {
//            if case .string(let value) = self.data {
//                return value
//            }
//            fatalError()
//        }
//        set {
//            self.data = .string(newValue)
//        }
//    }
//}
