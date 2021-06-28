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

//public struct Node<InputData: Codable, OutputData: Codable>: NodeProtocol {
//
//    public var id: String
//
//    public var title: String
//
//    public var value: String = ""
//
//    public var position: CGPoint = .zero
//
//    public var offset: CGSize = .zero
//
//    public var size: CGSize = .zero
//
//    public var inputs: [InputPort<InputData>] = []
//
//    public var outputs: [OutputPort<OutputData>] = []
//
//    public init(
//        id: String,
//        title: String,
//        position: CGPoint,
//        inputs: [InputPort<InputData>] = [],
//        outputs: [OutputPort<OutputData>] = []
//    ) {
//        self.id = id
//        self.title = title
//        self.position = position
//        self.inputs = inputs
//        self.outputs = outputs
//    }
//}
