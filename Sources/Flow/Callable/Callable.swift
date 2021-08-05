//
//  Callable.swift
//  
//
//  Created by nori on 2021/07/13.
//

import Foundation

public protocol Callable {

    typealias Input = [PortData]

    typealias Output = [PortData]

    typealias ID = String

    var id: ID { get }

    func callAsFunction(_ input: Input, _ output: Output) -> [PortData]

    func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData
}

extension Callable {

    public func callAsFunction(_ input: Input, _ output: Output) -> [PortData] {
        return output.enumerated().map { index, _ in
            return self(input: input, output: output, index: index)
        }
    }
}

public protocol CallableFunctionsProtocol {

    subscript(id: Callable.ID) -> Callable? { get }
}

public struct AnyCallable: Callable {

    public var id: ID { graph.id }

    public var graph: Graph

    public var delegate: CallableFunctionsProtocol

    public init(graph: Graph, delegate: CallableFunctionsProtocol) {
        self.graph = graph
        self.delegate = delegate
    }

    public func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData {
        let node = ouputNodes[index]
        let port = node.outputs.first!
        return data(node: node, port: port, input: input)!
    }
}

extension AnyCallable {

    var nodes: [Node] { graph.nodes }

    var edges: [Edge] { graph.edges }

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
        return connectedEdge.compactMap { self.graph[$0.source.id] }
    }

    func connectedSourceAddress(node: Node, inputPort: Port) -> Address? {
        guard let connectedEdge = self.edges.filter({ $0.target ==  inputPort.address }).first else { return nil }
        return connectedEdge.source
    }

    func data(for address: Address, input fromOutside: Input) -> PortData? {
        guard let node: Node = nodes[address.id] else {
            return nil
        }
        guard let port: Port = node[address.port] else {
            return nil
        }
        return data(node: node, port: port, input: fromOutside)
    }

    func data(node: Node, port: Port, input fromOutside: Input) -> PortData? {
        switch (node.type, port.type) {
            case (.io, .input), (.reference, .input):
                guard let address = connectedSourceAddress(node: node, inputPort: port) else {
                    return port.data
                }
                return data(for: address, input: fromOutside)
            case (.io(let typeID), .output), (.reference(let typeID), .output):
                let input = node.inputs.compactMap { input -> PortData? in
                    if input.data.exists {
                        return input.data
                    }
                    guard let address = connectedSourceAddress(node: node, inputPort: input) else {
                        return input.data
                    }
                    let data = self.data(for: address, input: fromOutside)
                    return data
                }
                guard let callable = delegate[typeID] else {
                    fatalError()
                }
                let output = callable(input, node.outputs.map({ $0.data }))
                let data = output[port.id]
                return data
            case (.input, .input): return port.data
            case (.input(let typeID), .output):
                let index = inputNodes.firstIndex(of: node)!
                let input = fromOutside[index]
                guard let callable = delegate[typeID] else {
                    fatalError()
                }
                let output = callable([input], node.outputs.map({ $0.data }))
                let data = output[port.id]
                return data
            case (.output, .input):
                guard let address = connectedSourceAddress(node: node, inputPort: port) else {
                    return port.data
                }
                return data(for: address, input: fromOutside)
            case (.output(let typeID), .output):
                let input = node.inputs.compactMap { input -> PortData? in
                    if input.data.exists {
                        return input.data
                    }
                    guard let address = connectedSourceAddress(node: node, inputPort: input) else {
                        return input.data
                    }
                    let data = self.data(for: address, input: fromOutside)
                    return data
                }
                guard let callable = delegate[typeID] else {
                    fatalError()
                }
                let output = callable(input, node.outputs.map({ $0.data }))
                print("cal out", node.id, node.type, input, output)
                let data = output[port.id]
                return data
        }
    }
}
