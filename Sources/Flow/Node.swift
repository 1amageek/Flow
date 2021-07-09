//
//  Node.swift
//  
//
//  Created by nori on 2021/06/21.
//

import Foundation
import CoreGraphics

public enum NodeType {
    case input(_ type: String? = nil)
    case output(_ type: String? = nil)
    case io(_ type: String? = nil)
}

public enum NodeError: Error {
    case convertError
    case mathematicalError
}

public struct Node: GeometryProperties, Identifiable {

    public typealias Input = [PortData]

    public typealias Output = [PortData]

    public typealias Execution = (Input) -> Output

    public var type: NodeType = .io()

    public var id: String

    public var name: String = ""

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public var inputs: [Port] = []

    public var outputs: [Port] = []

    public var execution: Execution = { input in input }

    public init(
        type: NodeType = .io(),
        id: String,
        name: String = "",
        inputs: [Interface] = [],
        outputs: [Interface] = [],
        position: CGPoint = .zero,
        execution: @escaping Execution = { input in input }
    ) {
        self.type = type
        self.id = id
        self.name = name
        self.position = position
        self.inputs = inputs.enumerated().map { .input(id: $0, data: $1.data, name: $1.name, node: self) }
        self.outputs = outputs.enumerated().map { .output(id: $0, data: $1.data, name: $1.name, node: self) }
        self.execution = execution
    }

    public func callAsFunction(_ input: Input) -> Output {
        return execution(input)
    }
}

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
        _ type: String? = nil,
        id: String,
        name: String,
        inputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .input(type), id: id, name: name, inputs: inputs, outputs: inputs, position: position)
    }

    public static func output(
        _ type: String? = nil,
        id: String,
        name: String,
        outputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .output(type), id: id, name: name, inputs: outputs, outputs: outputs, position: position)
    }

    public static func io(
        _ type: String? = nil,
        id: String,
        name: String,
        inputs: [Interface] = [],
        outputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(type), id: id, name: name, inputs: inputs, outputs: outputs, position: position)
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
