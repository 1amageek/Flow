//
//  Node.swift
//  
//
//  Created by nori on 2021/06/21.
//

import Foundation
import CoreGraphics

/// NodeType defines the identifier of the function that Node is responsible for in addition to input, output, and io.
/// type: {
///     kind: "io" | "output" | "input",
///     id: String
/// }
public enum NodeType: Hashable {
    case input(_ id: Callable.ID = Node.Function.bypass)
    case output(_ id: Callable.ID = Node.Function.bypass)
    case io(_ id: Callable.ID = Node.Function.bypass)
}

public enum NodeError: Error {
    case convertError
    case mathematicalError
}

public struct Node: GeometryProperties, Identifiable {

    public var type: NodeType = .io(Node.Function.bypass)

    public var id: String

    public var name: String = ""

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public var inputs: [Port] = []

    public var outputs: [Port] = []

    public init(
        type: NodeType = .io(),
        id: String,
        name: String = "",
        inputs: [Interface] = [],
        outputs: [Interface] = [],
        position: CGPoint = .zero
    ) {
        self.type = type
        self.id = id
        self.name = name
        self.position = position
        self.inputs = inputs.enumerated().map { .input(id: $0, data: $1.data, name: $1.name, nodeID: self.id) }
        self.outputs = outputs.enumerated().map { .output(id: $0, data: $1.data, name: $1.name, nodeID: self.id) }
    }

    public mutating func set(_ position: CGPoint) -> Self {
        self.position = position
        return self
    }

    public mutating func setInputs(_ inputs: [Interface]) -> Self {
        self.inputs = inputs.enumerated().map { index, interface in
            var port = Port.input(id: index, data: interface.data, name: interface.name, nodeID: self.id)
            if let input = self.inputs[index] {
                return port.set(input.position)
            }
            return port
        }
        return self
    }

    public mutating func setOutputs(_ outputs: [Interface]) -> Self {
        self.outputs = outputs.enumerated().map { index, interface in
            var port = Port.output(id: index, data: interface.data, name: interface.name, nodeID: self.id)
            if let input = self.outputs[index] {
                return port.set(input.position)
            }
            return port
        }
        return self
    }
}

extension Node: Equatable { }

extension Node {

    public subscript(port: Address.Port) -> Port {
        get {
            switch port {
                case .input(let index): return inputs[index]
                case .output(let index): return outputs[index]
            }
        }
        set {
            switch port {
                case .input(let index): inputs[index] = newValue
                case .output(let index): outputs[index] = newValue
            }
        }
    }
}

extension Node {

    public static func input(
        _ type: Callable.ID = Node.Function.bypass,
        id: String,
        name: String,
        inputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .input(type), id: id, name: name, inputs: inputs, outputs: inputs, position: position)
    }

    public static func output(
        _ type: Callable.ID = Node.Function.bypass,
        id: String,
        name: String,
        outputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .output(type), id: id, name: name, inputs: outputs, outputs: outputs, position: position)
    }

    public static func io(
        _ type: Callable.ID = Node.Function.bypass,
        id: String,
        name: String,
        inputs: [Interface] = [],
        outputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(type), id: id, name: name, inputs: inputs, outputs: outputs, position: position)
    }

    public static func sum(
        id: String,
        name: String,
        inputs: [Interface] = [],
        outputType: PortData,
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(Function.sum), id: id, name: name, inputs: inputs, outputs: [Interface(outputType)], position: position)
    }

    public static func product(
        id: String,
        name: String,
        inputs: [Interface] = [],
        outputType: PortData,
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(Function.product), id: id, name: name, inputs: inputs, outputs: [Interface(outputType)], position: position)
    }

    public static func average(
        id: String,
        name: String,
        inputs: [Interface] = [],
        outputType: PortData,
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(Function.average), id: id, name: name, inputs: inputs, outputs: [Interface(outputType)], position: position)
    }

    public static func varp(
        id: String,
        name: String,
        inputs: [Interface] = [],
        outputType: PortData,
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(Function.varp), id: id, name: name, inputs: inputs, outputs: [Interface(outputType)], position: position)
    }
}

extension Node {

    var debugDescription: String {
"""
    id: \(id)
    name: \(name)
    position: \(position)
    offset: \(offset)
    frame: \(frame)
    inputs: \(inputs)
    outputs: \(outputs)
"""
    }
}
