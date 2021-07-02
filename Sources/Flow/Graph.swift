//
//  Graph.swift
//  
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public class Graph<T: PortProperties & GeometryProperties & Identifiable>: ObservableObject where T.ID == String {

    @Published var nodes: [T] = []

    @Published var edges: [Edge] = []

    @Published var focusNode: Node<Any, Any>?

    @Published var connecting: Connection?

    public subscript(nodeID: String) -> T {
        get {
            let index = self.nodes.firstIndex(where: { $0.id == nodeID })!
            return nodes[index]
        }
        set {
            let index = self.nodes.firstIndex(where: { $0.id == nodeID })!
            nodes[index] = newValue
        }
    }

    public init(nodes: [T] = [], edges: [Edge] = []) {
        self._nodes = Published(initialValue: nodes)
        self._edges = Published(initialValue: edges)
    }

    public func port(with address: Address) -> PortInfo? {
        guard let node = nodes[address.id] else { return nil }
        switch address.port {
            case .input(let index): return node.inputPorts[index]
            case .output(let index): return node.outputPorts[index]
        }
    }

    public func position(with address: Address) -> CGPoint? {
        guard let node = nodes[address.id] else { return nil }
        guard let port = port(with: address) else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width - node.size.width / 2 + port.position.x,
            y: node.position.y + node.offset.height - node.size.height / 2 + port.position.y
        )
    }

    public func node(at point: CGPoint) -> T? {
        for (_, node) in nodes.enumerated() {
            if let node = nodes[node.id] {
                let frame = CGRect(
                    origin: CGPoint(
                        x: node.position.x - node.size.width / 2,
                        y: node.position.y - node.size.height / 2
                    ),
                    size: node.size
                )
                if frame.contains(point) {
                    return node
                }
            }
        }
        return nil
    }

    public func inputPortAddress(at point: CGPoint) -> Address? {
        guard let node = node(at: point) else { return nil }
        for (index, port) in node.inputPorts.enumerated() {
            let frame = CGRect(
                x: node.frame.origin.x + port.frame.origin.x,
                y: node.frame.origin.y + port.frame.origin.y,
                width: port.size.width,
                height: port.size.height)
            if frame.contains(point) {
                return Address(id: node.id, port: .input(index))
            }
        }
        return nil
    }

    public func outputPortAddress(at point: CGPoint) -> Address? {
        guard let node = node(at: point) else { return nil }
        for (index, port) in node.outputPorts.enumerated() {
            let frame = CGRect(
                x: node.frame.origin.x + port.frame.origin.x,
                y: node.frame.origin.y + port.frame.origin.y,
                width: port.size.width,
                height: port.size.height)
            if frame.contains(point) {
                return Address(id: node.id, port: .output(index))
            }
        }
        return nil
    }
}
//
//extension Graph {
//
//    public var inputNodes: [Node] { nodes.filter { $0.type == .input } }
//
//    public var ouputNodes: [Node] { nodes.filter { $0.type == .output } }
//
//    public func connectedNodes(node: Node, inputPort: Port) -> [Node] {
//        let connectedEdge = self.edges.filter { $0.target ==  Address(nodeID: node.id, portID: inputPort.id) }
//        return connectedEdge.map { self[$0.source.nodeID] }
//    }
//
//    public func connectedAddress(node: Node, inputPort: Port) -> Address {
//        let connectedEdge = self.edges.filter { $0.target ==  Address(nodeID: node.id, portID: inputPort.id) }.first!
//        return connectedEdge.source
//    }
//
//    public func data(for address: Address) -> PortData? {
//        let node: Node = self.nodes[address.nodeID]!
//        let port: Port = node[address.portID]
//        return data(node: node, port: port)
//    }
//
//    public func data(node: Node, port: Port) -> PortData? {
//        switch (node.type, port.type) {
//            case (.io, .input):
//                return data(for: connectedAddress(node: node, inputPort: port))
//            case (.io, .output): do {
//                let inputs = node.inputs.map { input -> Port in
//                    let address = connectedAddress(node: node, inputPort: input)
//                    let data = self.data(for: address)
//                    return Port.input(id: input.id, title: input.title, data: data)
//                }
//                let portData = node.execute(inputs, node.outputs)
//                let data = portData[port.id]
//                return data
//            }
//            case (.input, .input): return nil
//            case (.input, .output): do {
//                let portData = node.execute(node.inputs, node.outputs)
//                let data = portData[port.id]
//                return data
//            }
//            case (.output, .input):
//                return data(for: connectedAddress(node: node, inputPort: port))
//            case (.output, .output): return nil
//        }
//    }
//}
