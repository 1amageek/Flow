//
//  Port.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation
import CoreGraphics

public protocol Connectable {

    associatedtype Value

    var value: Value { get }
}

public typealias PortIndex = Array<PortInfo>.Index

public struct Port<T>: Connectable {

    public typealias Value = T

    public var title: String?

    public var value: T

    public init(_ value: Value, title: String? = nil) {
        self.value = value
        self.title = title
    }
}

public struct PortInfo: GeometryProperties {

    public var title: String?

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public init(title: String? = nil) {
        self.title = title
    }
}

public struct PortGroup<T>: Connectable {

    public typealias Value = T

    public var value: T

    public var ports: [PortInfo] = []

    public init(_ value: T, ports: [PortInfo]) {
        self.value = value
        self.ports = ports
    }
}

@resultBuilder
public struct PortBuilder {

    public static func buildBlock() -> PortGroup<()> {
        return PortGroup<()>((), ports: [])
    }

    public static func buildBlock<Content>(_ content: Port<Content>) -> PortGroup<Content> {
        return PortGroup<Content>(content.value, ports: [PortInfo(title: content.title)])
    }

    public static func buildBlock<C0, C1>(_ c0: Port<C0>, _ c1: Port<C1>) -> PortGroup<(C0, C1)> {
        return PortGroup((c0.value, c1.value), ports: [PortInfo(title: c0.title), PortInfo(title: c1.title)])
    }

    public static func buildBlock<C0, C1, C2>(_ c0: Port<C0>, _ c1: Port<C1>, _ c2: Port<C2>) -> PortGroup<(C0, C1, C2)> {
        return PortGroup((c0.value, c1.value, c2.value), ports: [PortInfo(title: c0.title), PortInfo(title: c1.title), PortInfo(title: c2.title)])
    }

    public static func buildBlock<C0, C1, C2, C3>(_ c0: Port<C0>, _ c1: Port<C1>, _ c2: Port<C2>, _ c3: Port<C3>) -> PortGroup<(C0, C1, C2, C3)> {
        return PortGroup((c0.value, c1.value, c2.value, c3.value), ports: [PortInfo(title: c0.title), PortInfo(title: c1.title), PortInfo(title: c2.title), PortInfo(title: c3.title)])
    }
}

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
