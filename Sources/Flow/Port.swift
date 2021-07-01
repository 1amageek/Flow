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

public struct Port: Identifiable, GeomertryProperties {

    public var type: PortType

    public var id: String

    public var title: String

    public var data: PortData?

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    init(type: PortType, id: String, title: String, data: PortData? = nil) {
        self.type = type
        self.id = id
        self.title = title
        self.data = data
    }

    public static func input(id: String, title: String, data: PortData? = nil) -> Port { Port(type: .input, id: id, title: title, data: data) }

    public static func output(id: String, title: String, data: PortData? = nil) -> Port { Port(type: .output, id: id, title: title, data: data) }

    public var text: String {
        get {
            guard let data = data else { return "" }
            switch data {
                case .none: return ""
                case .int(let value): return "\(value)"
                case .float(let value): return "\(value)"
                case .string(let value): return value
            }
        }
        set {
            guard let data = data else {
                self.data = .string(newValue)
                return
            }
            switch data {
                case .none: self.data = PortData.none
                case .int(_): self.data = .int(Int(newValue) ?? 0)
                case .float(_): self.data = .float(Float(newValue) ?? 0)
                case .string(_): self.data = .string(newValue)
            }
        }
    }
}

public extension Port {

    var intValue: Int {
        get {
            if case .int(let value) = self.data {
                return value
            }
            fatalError()
        }
        set {
            self.data = .int(newValue)
        }
    }

    var floatValue: Float {
        get {
            if case .float(let value) = self.data {
                return value
            }
            fatalError()
        }
        set {
            self.data = .float(newValue)
        }
    }

    var stringValue: String {
        get {
            if case .string(let value) = self.data {
                return value
            }
            fatalError()
        }
        set {
            self.data = .string(newValue)
        }
    }
}
