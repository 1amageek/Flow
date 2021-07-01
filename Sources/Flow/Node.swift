//
//  Node.swift
//  
//
//  Created by nori on 2021/06/21.
//

import Foundation
import CoreGraphics

public enum NodeType {
    case input
    case output
    case io
}

public extension Node {

    var inputs: [Port] { ports.filter { $0.type == .input } }

    var outputs: [Port] { ports.filter { $0.type == .output } }
}

public struct Node: Identifiable, GeomertryProperties {

    public var type: NodeType = .io

    public var id: String

    public var title: String

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public var ports: [Port] = []

    var execute: ([Port], [Port]) -> [Port.ID: PortData]

    public init(
        type: NodeType = .io,
        id: String,
        title: String,
        position: CGPoint,
        ports: [Port] = [],
        execute: @escaping ([Port], [Port]) -> [Port.ID: PortData]
    ) {
        self.type = type
        self.id = id
        self.title = title
        self.position = position
        self.ports = ports
        self.execute = execute
    }

    public subscript(portID: Port.ID) -> Port {
        get {
            let index = self.ports.firstIndex(where: { $0.id == portID })!
            return ports[index]
        }
        set {
            let index = self.ports.firstIndex(where: { $0.id == portID })!
            ports[index] = newValue
        }
    }

    public static func input(
        id: String,
        title: String,
        position: CGPoint,
        ports: [Port] = []
    ) -> Node {
        Node(type: .input, id: id, title: title, position: position, ports: ports) { _, outputs in
            outputs.reduce([:]) { prev, current in
                var now = prev
                now[current.id] = current.data
                return now
            }
        }
    }

    public static func output(
        id: String,
        title: String,
        position: CGPoint,
        ports: [Port] = []
    ) -> Node {
        Node(type: .output, id: id, title: title, position: position, ports: ports) { _, _ in [:] }
    }
}
