//
//  Port.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation
import CoreGraphics

public protocol Port: Identifiable, GeomertryProperties {

    associatedtype Data

    var id: String { get }

    var title: String { get }

    var data: Data { get set }
}

public struct InputPort<Data: Codable>: Port {

    public var id: String

    public var title: String

    public var data: Data

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public init(id: String, title: String, data: Data) {
        self.id = id
        self.title = title
        self.data = data
    }
}

public struct OutputPort<Data: Codable>: Port {

    public var id: String

    public var title: String

    public var data: Data

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public init(id: String, title: String, data: Data) {
        self.id = id
        self.title = title
        self.data = data
    }
}
