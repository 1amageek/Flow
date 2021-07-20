//
//  Graph.swift
//  
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public struct Graph: Codable {

    public var nodes: [Node] = []

    public var edges: [Edge] = []

    public subscript(nodeID: String) -> Node? {
        get {
            guard let index = self.nodes.firstIndex(where: { $0.id == nodeID }) else { return nil }
            return nodes[index]
        }
        set {
            guard let index = self.nodes.firstIndex(where: { $0.id == nodeID }) else { return }
            if let value = newValue {
                nodes[index] = value
            } else {
                nodes.remove(at: index)
            }
        }
    }

    public subscript(address: Address) -> Port? {
        guard let node = nodes[address.id] else { return nil }
        guard let port = node[address.port] else { return nil }
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

    public static func from(snapshot: Snapshot) -> Graph { snapshot.graph }

    public mutating func add(_ node: Node) {
        self.nodes.append(node)
    }

    public mutating func delete(_ node: Node) {
        self.nodes[node.id] = nil
        self.edges = self.edges.filter { edge in
            return edge.source.id != node.id && edge.target.id != node.id
        }
    }

    public func dump() throws -> Data {
        let snapshot: Snapshot = Snapshot(self)
        return try JSONEncoder().encode(snapshot)
    }
}

extension Graph {
    
    public struct Snapshot: Codable {

        public var graph: Graph

        public init(_ graph: Graph) {
            self.graph = graph
        }
    }
}

extension Graph.Snapshot: CustomDebugStringConvertible {

    public var debugDescription: String {

        func portDescription(_ ports: [Port]) -> String {
            return ports.map({ port in
                return "[\(port.type), id: \(port.id), data: \(port.data), name: \(port.name ?? ""), position: \(port.position)]"
            }).joined(separator: "\n   ")
        }

        let nodesDescription: String = graph.nodes.map { node in
            return "[\(node.type), id: \(node.id), name: \(node.name), position: \(node.position)]\n   \(portDescription(node.inputs))\n   \(portDescription(node.outputs)) "
        }.joined(separator: "\n")

        let edgesDescription: String = graph.edges.map { edge in
            return "[\(edge.id), target: \(edge.target), source: \(edge.source)]"
        }.joined(separator: "\n")

        return
"""
**
Graph Snapshot (Nodes count: \(graph.nodes.count) Edges count: \(graph.edges.count))
NODES
\(nodesDescription)
EDGES
\(edgesDescription)
"""
    }

}
