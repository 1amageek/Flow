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

    @Published public var cluster: Cluster

    @Published public var selectedGraph: Graph.ID?

    @Published public var focusNode: Node?

    @Published public var connecting: Connection?

    @Published var cache: Cache = Cache()

    private static var filename = "database.json"

    private static var applicationSupportDirectory: URL { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! }

    private static var databaseFileUrl: URL { applicationSupportDirectory.appendingPathComponent(filename) }

    public init(cluster: Cluster = Cluster(), addtionalFunctions: [Callable] = []) {
        self.cluster = cluster
        self.callableFunctions = CallableFunctions(cluster: cluster, addtionalFunctions: addtionalFunctions)
    }

    var visibleNodesTask: DispatchWorkItem?

    var visibleEdgesTask: DispatchWorkItem?

    let taskQueue: DispatchQueue = DispatchQueue(label: "inc.stamp.flow.queue")

    public var callableFunctions: CallableFunctions

    public var graph: Graph? {
        get {
            guard let id = selectedGraph else { return nil }
            return graphs[id]
        }
        set {
            guard let id = selectedGraph else { return }
            graphs[id] = newValue
        }
    }

    public var graphs: [Graph] {
        get { cluster.graphs }
        set { cluster.graphs = newValue }
    }

    public subscript(id: Graph.ID) -> Graph? {
        get { graphs[id] }
        set { graphs[id] = newValue }
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

    public class func local() -> FlowDocument {
        if let data = FileManager.default.contents(atPath: databaseFileUrl.path) {
            let cluster = loadData(from: data)
            return FlowDocument(cluster: cluster)
        } else {
            if let bundledDatabaseUrl = Bundle.main.url(forResource: "database", withExtension: "json") {
                if let data = FileManager.default.contents(atPath: bundledDatabaseUrl.path) {
                    let cluster = loadData(from: data)
                    return FlowDocument(cluster: cluster)
                }
            }
        }
        return FlowDocument()
    }

    private static func loadData(from storeFileData: Data) -> Cluster {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(Cluster.self, from: storeFileData)
        } catch {
            print(error)
            return Cluster()
        }
    }

    public func save() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(cluster)
            if FileManager.default.fileExists(atPath: Self.databaseFileUrl.path) {
                try FileManager.default.removeItem(at: Self.databaseFileUrl)
            }
            try data.write(to: Self.databaseFileUrl)
        } catch {
            print(error)
        }
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

    public func add(graph: Graph, undoManager: UndoManager? = nil) {
        graphs.append(graph)
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.delete(graph: graph, undoManager: undoManager)
        }
    }

    public func delete(graph: Graph, undoManager: UndoManager? = nil) {
        let old = graph
        graphs[graph.id] = nil
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.add(graph: old, undoManager: undoManager)
        }
    }

    public func replace(graph: Graph, undoManager: UndoManager? = nil) {
        let old = graph
        graphs[graph.id] = graph
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replace(graph: old, undoManager: undoManager)
        }
    }

    public func add(node: Node, undoManager: UndoManager? = nil) {
        let old = node
        nodes.append(node)
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.delete(node: old, undoManager: undoManager)
        }
    }

    public func delete(node: Node, undoManager: UndoManager? = nil) {
        let old = node
        nodes[node.id] = nil
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.add(node: old, undoManager: undoManager)
        }
    }

    public func replace(node: Node, undoManager: UndoManager? = nil) {
        let old = node
        nodes[node.id] = node
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replace(node: old, undoManager: undoManager)
        }
    }

    public func add(edge: Edge, undoManager: UndoManager? = nil) {
        let old = edge
        edges.append(edge)
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.delete(edge: old, undoManager: undoManager)
        }
    }

    public func delete(edge: Edge, undoManager: UndoManager? = nil) {
        let old = edge
        edges[edge.id] = nil
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.add(edge: old, undoManager: undoManager)
        }
    }

    public func replace(edge: Edge, undoManager: UndoManager? = nil) {
        let old = edge
        edges[edge.id] = edge
        undoManager?.registerUndo(withTarget: self) { doc in
            doc.replace(edge: old, undoManager: undoManager)
        }
    }
}


extension FlowDocument {

    func shouldConnect( _ connection: Connection) -> Bool { shouldConnectNodeHandler(self.nodes, self.edges, connection) }
}

/// Process required to draw the port.
extension FlowDocument {

    var nodes: [Node] {
        get { graph?.nodes ?? [] }
        set { graph?.nodes = newValue }
    }

    var edges: [Edge] {
        get { graph?.edges ?? [] }
        set { graph?.edges = newValue }
    }

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
            case (.io, .input), (.reference, .input):
                guard let address = connectedSourceAddress(node: node, inputPort: port) else {
                    return port.data
                }
                return data(for: address)
            case (.io(let typeID), .output), (.reference(let typeID), .output):
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
                let key: DataStore.Key = .init(id: node.id, input: input)
//                if let cache = self.dataStore[key] {
//                    return cache[port.id]
//                }
                guard let callable = self.callableFunctions[typeID] else {
                    fatalError()
                }
                let output = callable(input, node.outputs.map({ $0.data }))
                self.dataStore[key] = output
                let data = output[port.id]
                return data
            case (.input, .input): return port.data
            case (.input(let typeID), .output):
                let input = node.inputs.map { $0.data }
                let key: DataStore.Key = .init(id: node.id, input: input)
//                if let cache = self.dataStore[key] {
//                    return cache[port.id]
//                }
                guard let callable = self.callableFunctions[typeID] else {
                    fatalError()
                }
                let output = callable(input, node.outputs.map({ $0.data }))
                self.dataStore[key] = output
                let data = output[port.id]
                return data
            case (.output, .input):
                guard let address = connectedSourceAddress(node: node, inputPort: port) else {
                    return port.data
                }
                return data(for: address)
            case (.output(let typeID), .output):
                let input = node.inputs.map { $0.data }
                let key: DataStore.Key = .init(id: node.id, input: input)
//                if let cache = self.dataStore[key] {
//                    return cache[port.id]
//                }
                guard let callable = self.callableFunctions[typeID] else {
                    fatalError()
                }
                let output = callable(input, node.outputs.map({ $0.data }))
                self.dataStore[key] = output
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
