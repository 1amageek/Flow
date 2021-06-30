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
    case `default`
}

public protocol Node: Identifiable, GeomertryProperties where ID == String {

    associatedtype Input: Port

    associatedtype Output: Port

    var type: NodeType { get }

    var id: String { get }

    var title: String { get }

    var position: CGPoint { get set }

    var offset: CGSize { get set }

    var size: CGSize { get set }

    var inputs: [Input] { get set }

    var outputs: [Output] { get set }

}

public extension Node {

    subscript(portID: String) -> Input {
        get {
            let index = self.inputs.firstIndex(where: { $0.id == portID })!
            return inputs[index]
        }
        set {
            let index = self.inputs.firstIndex(where: { $0.id == portID })!
            inputs[index] = newValue
        }
    }
}

public struct IONode: Node {

    public typealias Input = InputPort

    public typealias Output = OutputPort

    public var type: NodeType = .default

    public var id: String

    public var title: String

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public var inputs: [Input] = []

    public var outputs: [Output] = []

//    let execute: ([Input]) -> [Output]

    public init(
        type: NodeType = .default,
        id: String,
        title: String,
        position: CGPoint,
        inputs: [Input] = [],
        outputs: [Output] = []
//        execute: @escaping ([Input]) -> [Output]
    ) {
        self.type = type
        self.id = id
        self.title = title
        self.position = position
        self.inputs = inputs
        self.outputs = outputs
//        self.execute = execute
    }

    public static func input(
        id: String,
        title: String,
        position: CGPoint,
        outputs: [Output] = []
    ) -> IONode {
        IONode(type: .input, id: id, title: title, position: position, outputs: outputs)
    }

    public static func output(
        id: String,
        title: String,
        position: CGPoint,
        inputs: [Input] = []
    ) -> IONode {
        IONode(type: .output, id: id, title: title, position: position, inputs: inputs)
    }
}
