//
//  Port.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation
import CoreGraphics

public protocol Port: Identifiable, GeomertryProperties where ID == String {

    associatedtype RawValue

    var id: ID { get }

    var title: String { get }

    var value: String { get }

    var data: RawValue { get }
}

public extension Port {

    var value: String { String("\(data)") }
}

public struct InputPort<RawValue>: Port {

    public var id: String

    public var title: String

    public var data: RawValue

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public init(id: String, title: String, data: RawValue) {
        self.id = id
        self.title = title
        self.data = data
    }
}

public struct OutputPort<RawValue>: Port {

    public var id: String

    public var title: String

    public var data: RawValue

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public init(id: String, title: String, data: RawValue) {
        self.id = id
        self.title = title
        self.data = data
    }
}
