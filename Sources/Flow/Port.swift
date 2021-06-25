//
//  Port.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation
import CoreGraphics

public protocol Port: Identifiable, GeomertryProperties {

    var id: String { get }

    var title: String { get }
}

public struct InputPort: Port {

    public var id: String

    public var title: String

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}

public struct OutputPort: Port {

    public var id: String

    public var title: String

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
