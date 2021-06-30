//
//  Port.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation
import CoreGraphics

public protocol Port: Identifiable, GeomertryProperties where ID == String {

    var id: ID { get }

    var title: String { get }

    var value: String { get }

    var data: PortData { get }
}

public extension Port {

    var value: String {
        switch data {
            case .none: return ""
            case .int(let value): return "\(value)"
            case .string(let value): return value
        }
    }
}

public struct InputPort: Port {

    public var id: String

    public var title: String

    public var data: PortData

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public init(id: String, title: String, data: PortData) {
        self.id = id
        self.title = title
        self.data = data
    }
}

public struct OutputPort: Port {

    public var id: String

    public var title: String

    public var data: PortData

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public init(id: String, title: String, data: PortData) {
        self.id = id
        self.title = title
        self.data = data
    }
}
