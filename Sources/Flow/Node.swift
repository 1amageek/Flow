//
//  Node.swift
//  
//
//  Created by nori on 2021/06/21.
//

import Foundation
import CoreGraphics

public struct Address: Hashable {

    public var nodeID: String

    public var portID: String

    public init(nodeID: String, portID: String) {
        self.nodeID = nodeID
        self.portID = portID
    }
}

public struct Port: Identifiable {

    public var id: String

    public var title: String

    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}

public struct Node: Identifiable {
    
    public var id: String

    public var title: String

    public var inputs: [Port] = []

    public var outputs: [Port] = []

    var ports: [Port] { inputs + outputs }

    public init(
        id: String,
        title: String,
        inputs: [Port] = [],
        outputs: [Port] = []
    ) {
        self.id = id
        self.title = title
        self.inputs = inputs
        self.outputs = outputs
    }
}

extension Node {
    struct Geometry {
        var frame: CGRect = .zero
        var size: CGSize = .zero
        var position: CGPoint = .zero
        var offset: CGSize = .zero
        var ports: [Port.ID: Port.Geometry] = [:]
    }
}

extension Port {
    struct Geometry {
        var frameOnCanvas: CGRect = .zero
        var frame: CGRect = .zero
        var size: CGSize = .zero
        var position: CGPoint = .zero
        var offset: CGSize = .zero
    }
}
