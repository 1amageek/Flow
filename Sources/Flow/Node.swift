//
//  Node.swift
//  
//
//  Created by nori on 2021/06/21.
//

import Foundation
import CoreGraphics

public enum NodeType {
    case input
    case output
    case io
}

public enum NodeError: Error {
    case convertError
    case mathematicalError
}

public struct Node: GeometryProperties, Identifiable {

    public typealias Input = [PortData]

    public typealias Output = [PortData]

    public typealias Execution = (Input) -> Output

    public var type: NodeType = .io

    public var id: String

    public var title: String?

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public var inputs: [Port] = []

    public var outputs: [Port] = []

    public var execution: Execution = { input in input }

    public init(
        type: NodeType = .io,
        id: String,
        title: String?,
        inputs: [Interface] = [],
        outputs: [Interface] = [],
        position: CGPoint = .zero,
        execution: @escaping Execution = { input in input }
    ) {
        self.type = type
        self.id = id
        self.title = title
        self.position = position
        self.inputs = inputs.enumerated().map { .input(id: $0, data: $1.data, title: $1.title, node: self) }
        self.outputs = outputs.enumerated().map { .output(id: $0, data: $1.data, title: $1.title, node: self) }
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
        id: String,
        title: String,
        inputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .input, id: id, title: title, inputs: inputs, outputs: inputs, position: position)
    }

    public static func output(
        id: String,
        title: String,
        outputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .output, id: id, title: title, inputs: outputs, outputs: outputs, position: position)
    }

    public static func io(
        id: String,
        title: String,
        inputs: [Interface] = [],
        outputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io, id: id, title: title, inputs: inputs, outputs: outputs, position: position)
    }
}

extension Node {

    var debugDescription: String {
"""
    id: \(id)
    title: \(title ?? "")
    position: \(position)
    offset: \(offset)
    frame: \(frame)
    inputs: \(inputs)
    outputs: \(outputs)
"""
    }
}
