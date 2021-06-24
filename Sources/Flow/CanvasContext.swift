//
//  CanvasContext.swift
//  
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

extension Array where Element == Node {
    subscript(id: Node.ID) -> Node? {
        get {
            guard let index = self.firstIndex(where: { $0.id == id }) else { return nil }
            return self[index]
        }
    }
}

extension Array where Element == Port {
    subscript(id: Port.ID) -> Port? {
        get {
            guard let index = self.firstIndex(where: { $0.id == id }) else { return nil }
            return self[index]
        }
    }
}

public class CanvasContext: ObservableObject {

    @Published var nodes: [Node] = []

    @Published var edges: [Edge] = []

    @Published var focusNode: Node?

    @Published var connecting: Connection?

    @Published var nodeGeometories: [Node.ID: Node.Geometry] = [:]

    var inputPorts: [Port] { nodes.reduce([], { prev, current in prev + current.inputs }) }

    var outputPorts: [Port] { nodes.reduce([], { prev, current in prev + current.outputs }) }

    public init(nodes: [Node] = [], edges: [Edge] = []) {
        self._nodes = Published(initialValue: nodes)
        self._edges = Published(initialValue: edges)
        self.nodeGeometories = nodes.reduce([:], { prev, current in
            var dict = prev
            var geometory = Node.Geometry()
            let ports: [Port.ID: Port.Geometry] = current.ports.reduce([:]) { prevPort, currentPort in
                var dict = prevPort
                dict[currentPort.id] = Port.Geometry()
                return dict
            }
            geometory.ports = ports
            dict[current.id] = geometory
            return dict
        })
    }

    public func portPosition(at address: Address) -> CGPoint? {
        guard let node: Node.Geometry = self.nodeGeometories[address.nodeID] else { return nil }
        guard let frame = node.ports[address.portID]?.frame else { return nil }
        return CGPoint(
            x: node.position.x + node.offset.width + frame.origin.x + frame.width / 2,
            y: node.position.y + node.offset.height + frame.origin.y + frame.height / 2
        )
    }

    public func node(at point: CGPoint) -> Node? {
        for (_, node) in nodes.enumerated() {
            if let geometory = nodeGeometories[node.id] {
                let frame = CGRect(
                    origin: CGPoint(
                        x: geometory.position.x - geometory.size.width / 2,
                        y: geometory.position.y - geometory.size.height / 2
                    ),
                    size: geometory.size
                )
                if frame.contains(point) {
                    return node
                }
            }
        }
        return nil
    }

    public func address(at point: CGPoint) -> Address? {
        guard let node = node(at: point) else { return nil }
        for (_, port) in node.ports.enumerated() {
            if let geometory = nodeGeometories[node.id]?.ports[port.id] {
                let frame = geometory.frameOnCanvas
                if frame.contains(point) {
                    return Address(nodeID: node.id, portID: port.id)
                }
            }
        }
        return nil
    }

    func checkInput(address: Address) -> Bool {
        guard let node = nodes[address.nodeID] else { return false }
        return node.inputs.contains(where: { $0.id == address.portID })
    }

    func checkOutput(address: Address) -> Bool {
        guard let node = nodes[address.nodeID] else { return false }
        return node.outputs.contains(where: { $0.id == address.portID })
    }

    public func edge(from connection: Connection) -> Edge? {
        guard let endAddress = connection.endAddress else {
            return nil
        }
        let startAddress = connection.startAddress


        let isInput = endAddress.nodeID






        return nil
    }
}
