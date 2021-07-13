//
//  Graph.swift
//  
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public struct Graph {

    public var nodes: [Node] = []

    public var edges: [Edge] = []

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

    public init(
        nodes: [Node] = [],
        edges: [Edge] = []
    ) {
        self.nodes = nodes
        self.edges = edges
    }

    public static func from(data: Data) throws -> Graph {
        let snapshot = try JSONDecoder().decode(Graph.Snapshot.self, from: data)
        return self.from(snapshot: snapshot)
    }

    public static func from(snapshot: Snapshot) -> Graph { Graph(nodes: snapshot.nodes, edges: snapshot.edges) }

    public mutating func add(_ node: Node) {
        self.nodes.append(node)
    }

    public mutating func delete(_ node: Node) {
        self.nodes[node.id] = nil
    }

    public func dump() throws -> Data {
        let snapshot: Snapshot = Snapshot(nodes: nodes, edges: edges)
        return try JSONEncoder().encode(snapshot)
    }
}

extension Graph {
    
    public struct Snapshot: Codable {

        public var nodes: [Node]

        public var edges: [Edge]

        public init(nodes: [Node] = [], edges: [Edge] = []) {
            self.nodes = nodes
            self.edges = edges
        }
    }
}

extension Graph.Snapshot: CustomDebugStringConvertible {

    public var debugDescription: String {

        func portDescription(_ ports: [Port]) -> String {
            return ports.map({ port in
                return "[\(port.type), id: \(port.id), data: \(port.data.text), name: \(port.name ?? ""), position: \(port.position)]"
            }).joined(separator: "\n   ")
        }

        let nodesDescription: String = nodes.map { node in
            return "[\(node.type), id: \(node.id), name: \(node.name), position: \(node.position)]\n   \(portDescription(node.inputs))\n   \(portDescription(node.outputs)) "
        }.joined(separator: "\n")

        let edgesDescription: String = edges.map { edge in
            return "[\(edge.id), target: \(edge.target), source: \(edge.source)]"
        }.joined(separator: "\n")

        return
"""
**
Graph Snapshot (Nodes count: \(nodes.count) Edges count: \(edges.count))
NODES
\(nodesDescription)
EDGES
\(edgesDescription)
"""
    }

}
