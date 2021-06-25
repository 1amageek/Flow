//
//  CanvasContext.swift
//  
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public class CanvasContext: ObservableObject {

    @Published var nodes: [Node] = []

    @Published var edges: [Edge] = []

    @Published var focusNode: Node?

    @Published var connecting: Connection?


    public init(nodes: [Node] = [], edges: [Edge] = []) {
        self._nodes = Published(initialValue: nodes)
        self._edges = Published(initialValue: edges)
    }

    public func position(at node: Node, port: InputPort) -> CGPoint? {
        guard let position = node.inputs[port.id]?.position else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width - node.size.width / 2 + position.x,
            y: node.position.y + node.offset.height - node.size.height / 2 + position.y
        )
    }

    public func position(at node: Node, port: OutputPort) -> CGPoint? {
        guard let position = node.outputs[port.id]?.position else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width - node.size.width / 2 + position.x,
            y: node.position.y + node.offset.height - node.size.height / 2 + position.y
        )
    }

    public func sourcePosition(address: Address) -> CGPoint? {
        guard let node = nodes[address.nodeID] else { return nil }
        guard let position = node.outputs[address.portID]?.position else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width - node.size.width / 2 + position.x,
            y: node.position.y + node.offset.height - node.size.height / 2 + position.y
        )
    }

    public func targetPosition(address: Address) -> CGPoint? {
        guard let node = nodes[address.nodeID] else { return nil }
        guard let position = node.inputs[address.portID]?.position else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width - node.size.width / 2 + position.x,
            y: node.position.y + node.offset.height - node.size.height / 2 + position.y
        )
    }

    public func node(at point: CGPoint) -> Node? {
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
