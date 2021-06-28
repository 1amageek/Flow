//
//  Node.swift
//  
//
//  Created by nori on 2021/06/21.
//

import Foundation
import CoreGraphics

public protocol Node: Identifiable, GeomertryProperties where ID == String {

    associatedtype Input: Port

    associatedtype Output: Port

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

public struct IONode<InputData, OutputData>: Node {

    public typealias Input = InputPort<InputData>

    public typealias Output = OutputPort<OutputData>

    public var id: String

    public var title: String

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public var inputs: [Input] = []

    public var outputs: [Output] = []

    let execute: ([InputData]) -> [OutputData]

    public init(
        id: String,
        title: String,
        position: CGPoint,
        inputs: [Input] = [],
        outputs: [Output] = [],
        execute: @escaping ([InputData]) -> [OutputData]
    ) {
        self.id = id
        self.title = title
        self.position = position
        self.inputs = inputs
        self.outputs = outputs
        self.execute = execute
    }
}

//public struct InputNode<OutputData>: Node {
//
//    public typealias Input = InputPort<OutputData>
//
//    public typealias Output = OutputPort<OutputData>
//
//    public var id: String
//
//    public var title: String
//
//    public var position: CGPoint = .zero
//
//    public var offset: CGSize = .zero
//
//    public var size: CGSize = .zero
//
//    public var inputs: [Input] = []
//
//    public var outputs: [Output] = []
//
//    let execute: ([OutputData]) -> [OutputData]
//
//    public init(
//        id: String,
//        title: String,
//        position: CGPoint,
//        outputs: [Output] = []
//    ) {
//        self.id = id
//        self.title = title
//        self.position = position
//        self.outputs = outputs
//        self.execute = { inputsData in inputsData }
//    }
//}
//
//public struct OutputNode<InputData>: Node {
//
//    public typealias Input = InputPort<InputData>
//
//    public typealias Output = OutputPort<InputData>
//
//    public var id: String
//
//    public var title: String
//
//    public var position: CGPoint = .zero
//
//    public var offset: CGSize = .zero
//
//    public var size: CGSize = .zero
//
//    public var inputs: [Input] = []
//
//    public var outputs: [Output] = []
//
//    let execute: ([InputData]) -> [InputData]
//
//    public init(
//        id: String,
//        title: String,
//        position: CGPoint,
//        inputs: [Input] = []
//    ) {
//        self.id = id
//        self.title = title
//        self.position = position
//        self.inputs = inputs
//        self.execute = { inputsData in inputsData }
//    }
//}
