//
//  Context.swift
//  
//
//  Created by nori on 2021/07/12.
//

import Foundation
import SwiftUI

public final class FlowDocument: ObservableObject {

    @Published public var canvas: Canvas = Canvas()

    @Published public var flow: Flow

    @Published public var selectedGraph: Graph.ID?

    @Published public var focusNode: Node?

    @Published public var connecting: Connection?

    @Published var cache: Cache = Cache()

    public init() {
        let graph: Graph = .placeholder
        let flow = Flow(graphs: [graph])
        self.flow = flow
        self.callableFunctions = CallableFunctions(flow: flow, addtionalFunctions: [])
        self.selectedGraph = graph.id
    }

    var visibleNodesTask: DispatchWorkItem?

    var visibleEdgesTask: DispatchWorkItem?

    let taskQueue: DispatchQueue = DispatchQueue(label: "inc.stamp.flow.queue")

    public var callableFunctions: CallableFunctions

    public var graph: Graph? {
        get {
            guard let id = selectedGraph else {
                return nil
            }
            return graphs[id]
        }
        set {
            guard let id = selectedGraph else { return }
            graphs[id] = newValue
        }
    }

    let dataStore: DataStore = DataStore()

    var shouldConnectNodeHandler: ((_ nodes: [Node], _ edges: [Edge], _ connection: Connection) -> Bool)!

    /// Get the calculation results for a port at an arbitrary address.
    /// - Parameter address: Address of the port you want to get.
    /// - Returns: Calculated data
    public func data(for address: Address) -> PortData? {
        guard let node: Node = nodes[address.id] else {
            return nil
        }
        guard let port: Port = node[address.port] else {
            return nil
        }
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

    private static func prepare(_ graph: Graph) -> Graph {
        let nodes = graph.nodes
        let edges = graph.edges.filter { edge in
            return nodes.contains(where: { $0.id == edge.source.id }) && nodes.contains(where: { $0.id == edge.target.id })
        }
        return Graph(nodes: nodes, edges: edges)
    }
}

extension FlowDocument {

    func shouldConnect( _ connection: Connection) -> Bool { shouldConnectNodeHandler(self.nodes, self.edges, connection) }
}

/// Process required to draw the port.
extension FlowDocument {

    var graphs: [Graph] {
        get { flow.graphs }
        set { flow.graphs = newValue }
    }

    var nodes: [Node] { graph?.nodes ?? [] }

    var edges: [Edge] { graph?.edges ?? [] }

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
extension FlowDocument {

    var inputNodes: [Node] {
        nodes.filter { node in
            if case .input(_) = node.type {
                return true
            }
            return false
        }
    }

    var ouputNodes: [Node] {
        nodes.filter { node in
            if case .output(_) = node.type {
                return true
            }
            return false
        }
    }

    func connectedSourceNodes(node: Node, inputPort: Port) -> [Node] {
        let connectedEdge = self.edges.filter { $0.target ==  inputPort.address }
        return connectedEdge.compactMap { self.graph?[$0.source.id] }
    }

    func connectedSourceAddress(node: Node, inputPort: Port) -> Address? {
        guard let connectedEdge = self.edges.filter({ $0.target ==  inputPort.address }).first else { return nil }
        return connectedEdge.source
    }

    func data(node: Node, port: Port) -> PortData? {
        switch (node.type, port.type) {
            case (.io, .input):
                guard let address = connectedSourceAddress(node: node, inputPort: port) else {
                    return port.data
                }
                return data(for: address)
            case (.io(let typeID), .output):
                let input = node.inputs.compactMap { input -> PortData? in
                    if input.data.exists {
                        return input.data
                    }
                    guard let address = connectedSourceAddress(node: node, inputPort: input) else {
                        return input.data
                    }
                    let data = self.data(for: address)
                    return data
                }
                if let cache = self.dataStore[input] {
                    return cache[port.id]
                }
                guard let callable = self.callableFunctions[typeID] else {
                    fatalError()
                }
                let output = callable(input, node.outputs.map({ $0.data }))
                self.dataStore[input] = output
                let data = output[port.id]
                return data
            case (.input, .input): return port.data
            case (.input(let typeID), .output):
                let input = node.inputs.map { $0.data }
                if let cache = self.dataStore[input] {
                    return cache[port.id]
                }
                guard let callable = self.callableFunctions[typeID] else {
                    fatalError()
                }
                let output = callable(input, node.outputs.map({ $0.data }))
                self.dataStore[input] = output
                let data = output[port.id]
                return data
            case (.output, .input):
                guard let address = connectedSourceAddress(node: node, inputPort: port) else {
                    return port.data
                }
                return data(for: address)
            case (.output(let typeID), .output):
                let input = node.inputs.map { $0.data }
                if let cache = self.dataStore[input] {
                    return cache[port.id]
                }
                guard let callable = self.callableFunctions[typeID] else {
                    fatalError()
                }
                let output = callable(input, node.outputs.map({ $0.data }))
                self.dataStore[input] = output
                let data = output[port.id]
                return data
        }
    }
}

extension FlowDocument {

    func visibleNodes(completion: @escaping ([Node]) -> Void) -> DispatchWorkItem {
        let visibleFrame = canvas.visibleFrame
        let nodes = graph?.nodes ?? []
        let cache = cache.nodes
        var task: DispatchWorkItem? = nil
        task = DispatchWorkItem {
            var visibleNodes: [Node] = []
            for node in nodes {
                if task!.isCancelled { break }
                if visibleFrame.intersects(node.frame) {
                    visibleNodes.append(node)
                }
            }
            if task!.isCancelled { return }
            if cache != visibleNodes {
                DispatchQueue.main.async {
                    completion(visibleNodes)
                }
            }
        }
        taskQueue.async(execute: task!)
        return task!
    }

    func visibleEdges(completion: @escaping ([Edge]) -> Void) -> DispatchWorkItem {
        let nodes = cache.nodes ?? []
        let edges = graph?.edges ?? []
        let cache = cache.edges
        var task: DispatchWorkItem? = nil
        task = DispatchWorkItem {
            var visibleEdges: [Edge] = []
            for edge in edges {
                if task!.isCancelled { break }
                if nodes.contains(where: { $0.id == edge.source.id }) || nodes.contains(where: { $0.id == edge.target.id }) {
                    visibleEdges.append(edge)
                }
            }
            if task!.isCancelled { return }
            if cache != visibleEdges {
                DispatchQueue.main.async {
                    completion(visibleEdges)
                }
            }
        }
        taskQueue.async(execute: task!)
        return task!
    }
}
