//
//  Cluster.swift
//  Cluster
//
//  Created by nori on 2021/07/25.
//

import SwiftUI

public struct Cluster: Codable {

    public var graphs: [Graph]

    public init(graphs: [Graph] = []) {
        self.graphs = graphs
    }
}


extension Cluster: CustomDebugStringConvertible {

    public var debugDescription: String {
        var debugDescriptions: [String] = []
        graphs.forEach { graph in
            debugDescriptions.append("[Graph: \(graph.id)] name: \(graph.name)")
            graph.nodes.forEach { node in
                debugDescriptions.append("  [Node: \(node.id)] name: \(node.name), type: \(node.type)")
                node.inputs.forEach { port in
                    debugDescriptions.append("    [Input: \(port.id)] name: \(port.name ?? ""), data: \(port.data)")
                }
                node.outputs.forEach { port in
                    debugDescriptions.append("    [Output: \(port.id)] name: \(port.name ?? ""), data: \(port.data)")
                }
            }
        }
        return debugDescriptions.joined(separator: "\n")
    }
}
