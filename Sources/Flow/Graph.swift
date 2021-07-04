//
//  Graph.swift
//  
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public class Graph: ObservableObject {

    @Published var canvas: Canvas = Canvas()

    @Published var nodes: [Node] = []

    @Published var edges: [Edge] = []

    @Published var focusNode: Node?

    @Published var connecting: Connection?

    public subscript(nodeID: String) -> Node {
        get {
            let index = self.nodes.firstIndex(where: { $0.id == nodeID })!
            return nodes[index]
        }
        set {
            let index = self.nodes.firstIndex(where: { $0.id == nodeID })!
            nodes[index] = newValue
        }
    }

    public subscript(address: Address) -> Port {
        let node = nodes[address.id]!
        let port = node[address.port]
        return port
    }

    public init(nodes: [Node] = [], edges: [Edge] = []) {
        self._nodes = Published(initialValue: nodes)
        self._edges = Published(initialValue: edges)
    }

    /// Get the calculation results for a port at an arbitrary address.
    /// - Parameter address: Address of the port you want to get.
    /// - Returns: Calculated data
    public func data(for address: Address) -> PortData {
        guard let node: Node = nodes[address.id] else {
            fatalError("[FLOW][WARNNING] address [\(address.id):\(address.port)] There are no nodes connected to this address.")
        }
        let port: Port = node[address.port]
        return data(node: node, port: port)
    }

    public func position(with address: Address) -> CGPoint? {
        guard let node = nodes[address.id] else { return nil }
        guard let port = port(with: address) else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width - node.size.width / 2 + port.position.x,
            y: node.position.y + node.offset.height - node.size.height / 2 + port.position.y
        )
    }

    public func add(_ node: Node) {
        self.nodes.append(node)
    }

    public func delete(_ node: Node) {
        self.nodes[node.id] = nil
    }
}

/// Process required to draw the port.
extension Graph {

    func port(with address: Address) -> Port? {
        guard let node = nodes[address.id] else { return nil }
        switch address.port {
            case .input(let index): return node.inputs[index]
            case .output(let index): return node.outputs[index]
        }
    }

    func node(at point: CGPoint) -> Node? {
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

    func inputPortAddress(at point: CGPoint) -> Address? {
        guard let node = node(at: point) else { return nil }
        for port in node.inputs {
            let frame = CGRect(
                x: node.frame.origin.x + port.frame.origin.x,
                y: node.frame.origin.y + port.frame.origin.y,
                width: port.size.width,
                height: port.size.height
            )
            if frame.contains(point) {
                return Address(id: node.id, port: .input(port.id))
            }
        }
        return nil
    }

    func outputPortAddress(at point: CGPoint) -> Address? {
        guard let node = node(at: point) else { return nil }
        for port in node.outputs {
            let frame = CGRect(
                x: node.frame.origin.x + port.frame.origin.x,
                y: node.frame.origin.y + port.frame.origin.y,
                width: port.size.width,
                height: port.size.height
            )
            if frame.contains(point) {
                return Address(id: node.id, port: .output(port.id))
            }
        }
        return nil
    }
}

/// Processing required to compute data for a node
extension Graph {

    var inputNodes: [Node] { nodes.filter { $0.type == .input } }

    var ouputNodes: [Node] { nodes.filter { $0.type == .output } }

    func connectedSourceNodes(node: Node, inputPort: Port) -> [Node] {
        let connectedEdge = self.edges.filter { $0.target ==  inputPort.address }
        return connectedEdge.map { self[$0.source.id] }
    }

    func connectedSourceAddress(node: Node, inputPort: Port) -> Address? {
        guard let connectedEdge = self.edges.filter({ $0.target ==  inputPort.address }).first else { return nil }
        return connectedEdge.source
    }

    func data(node: Node, port: Port) -> PortData {
        switch (node.type, port.type) {
            case (.io, .input):
                guard let address = connectedSourceAddress(node: node, inputPort: port) else {
                    return port.data
                }
                return data(for: address)
            case (.io, .output): do {
                let input = node.inputs.map { input -> PortData in
                    guard let address = connectedSourceAddress(node: node, inputPort: input) else {
                        return port.data
                    }
                    let data = self.data(for: address)
                    return data
                }
                let portData = node(input)
                let data = portData[port.id]
                return data
            }
            case (.input, .input): return port.data
            case (.input, .output): do {
                let input = node.inputs
                let output = node(input.map { $0.data })
                let data = output[port.id]
                return data
            }
            case (.output, .input):
                guard let address = connectedSourceAddress(node: node, inputPort: port) else {
                    return port.data
                }
                return data(for: address)
            case (.output, .output): do {
                let input = node.inputs
                let output = node(input.map { $0.data })
                let data = output[port.id]
                return data
            }
        }
    }
}
