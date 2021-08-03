//
//  Graph.swift
//  
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public struct Graph: Identifiable, Codable {

    public var id: String

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
        id: String = UUID().uuidString,
        nodes: [Node] = [],
        edges: [Edge] = []
    ) {
        self.id = id
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
    public static var placeholder: Self {
        Graph(
            nodes: [
                .input(id: "R", name: "R", inputs: [.float(name: "R")], position: CGPoint(x: 200, y: 200)),
                .input(id: "G", name: "G", inputs: [.float(name: "B")], position: CGPoint(x: 200, y: 400)),
                .input(id: "B", name: "B", inputs: [.float(name: "B")], position: CGPoint(x: 200, y: 600)),
                .sum(id: "SUM", name: "SUM", inputs: [.float(), .float(), .float()], outputType: .float(), position: CGPoint(x: 400, y: 400)),
                .output(id: "OUT", name: "OUT", outputs: [.float()], position: CGPoint(x: 650, y: 400)),

                    .input(id: "DATAA", name: "DATA A", inputs: [.floatArray([1, 2, 3, 4], name: "R")], position: CGPoint(x: 200, y: 900)),
                .input(id: "DATAB", name: "DATA B", inputs: [.floatArray([1, 2, 3, 4], name: "R")], position: CGPoint(x: 200, y: 1100)),
                .product(id: "PRODUCT", name: "PRODUCT", inputs: [.floatArray(), .floatArray()], outputType: .float(), position: CGPoint(x: 400, y: 1000)),

            ],
            edges: [
                Edge(source: .output("R", index: 0), target: .input("SUM", index: 0)),
                Edge(source: .output("G", index: 0), target: .input("SUM", index: 1)),
                Edge(source: .output("B", index: 0), target: .input("SUM", index: 2)),
                Edge(source: .output("SUM", index: 0), target: .input("OUT", index: 0)),

                Edge(source: .output("DATAA", index: 0), target: .input("PRODUCT", index: 0)),
                Edge(source: .output("DATAB", index: 0), target: .input("PRODUCT", index: 1)),
            ])
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
