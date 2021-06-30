//
//  Graph.swift
//  
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public class Graph<NodeElement: Node>: ObservableObject {

    @Published var nodes: [NodeElement] = []

    @Published var edges: [Edge] = []

    @Published var focusNode: NodeElement?

    @Published var connecting: Connection?

    public subscript(nodeID: String) -> NodeElement {
        get {
            let index = self.nodes.firstIndex(where: { $0.id == nodeID })!
            return nodes[index]
        }
        set {
            let index = self.nodes.firstIndex(where: { $0.id == nodeID })!
            nodes[index] = newValue
        }
    }

    public init(nodes: [NodeElement] = [], edges: [Edge] = []) {
        self._nodes = Published(initialValue: nodes)
        self._edges = Published(initialValue: edges)
    }

    public func position<Element: Node>(at node: Element, port: Element.Input) -> CGPoint? {
        guard let position = node.inputs[port.id]?.position else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width - node.size.width / 2 + position.x,
            y: node.position.y + node.offset.height - node.size.height / 2 + position.y
        )
    }

    public func position<Element: Node>(at node: Element, port: Element.Output) -> CGPoint? {
        guard let position = node.outputs[port.id]?.position else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width - node.size.width / 2 + position.x,
            y: node.position.y + node.offset.height - node.size.height / 2 + position.y
        )
    }

    public func sourcePosition(address: Address) -> CGPoint? where NodeElement.ID == String, NodeElement.Output.ID == String {
        guard let node = nodes[address.nodeID] else { return nil }
        guard let position = node.outputs[address.portID]?.position else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width - node.size.width / 2 + position.x,
            y: node.position.y + node.offset.height - node.size.height / 2 + position.y
        )
    }

    public func targetPosition(address: Address) -> CGPoint? where NodeElement.ID == String, NodeElement.Input.ID == String {
        guard let node = nodes[address.nodeID] else { return nil }
        guard let position = node.inputs[address.portID]?.position else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width - node.size.width / 2 + position.x,
            y: node.position.y + node.offset.height - node.size.height / 2 + position.y
        )
    }

    public func node(at point: CGPoint) -> NodeElement? {
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
        for (_, port) in node.inputs.enumerated() {
            let frame = CGRect(
                x: node.frame.origin.x + port.frame.origin.x,
                y: node.frame.origin.y + port.frame.origin.y,
                width: port.size.width,
                height: port.size.height)
            if frame.contains(point) {
                return Address(nodeID: node.id, portID: port.id)
            }
        }
        return nil
    }

    public func outputPortAddress(at point: CGPoint) -> Address? {
        guard let node = node(at: point) else { return nil }
        for (_, port) in node.outputs.enumerated() {
            let frame = CGRect(
                x: node.frame.origin.x + port.frame.origin.x,
                y: node.frame.origin.y + port.frame.origin.y,
                width: port.size.width,
                height: port.size.height)
            if frame.contains(point) {
                return Address(nodeID: node.id, portID: port.id)
            }
        }
        return nil
    }
}

extension Graph {

    public var inputNodes: [NodeElement] { nodes.filter { $0.type == .input } }

    public var ouputNodes: [NodeElement] { nodes.filter { $0.type == .output } }

    public func connectedNodes(node: NodeElement, inputPort: InputPort) -> [NodeElement] {
        let connectedEdge = self.edges.filter { $0.target ==  Address(nodeID: node.id, portID: inputPort.id) }
        return connectedEdge.map { self[$0.source.nodeID] }
    }

    public func connectedPorts(node: NodeElement, inputPort: InputPort) -> [OutputPort] {
        let connectedEdge = self.edges.filter { $0.target ==  Address(nodeID: node.id, portID: inputPort.id) }
        return connectedEdge.compactMap { self[$0.source.nodeID].outputs[$0.source.portID] as! OutputPort }
    }

    public func execute() {
        ouputNodes.forEach { node in
            node.inputs.forEach { port in
                if let port = port as? InputPort {
                    let nodes = connectedNodes(node: node, inputPort: port)
//                    port.data = .int(12)
                }
            }
        }
    }

    public func probe(node: NodeElement, port: InputPort) -> PortData {
        let nodes = connectedNodes(node: node, inputPort: port)

        nodes.forEach { node in

        }
    }

}
