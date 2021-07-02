//
//  Node.swift
//  
//
//  Created by nori on 2021/06/21.
//

import Foundation
import CoreGraphics

public protocol Convertible {

    associatedtype Input: Connectable

    associatedtype Output: Connectable

    @PortBuilder var input: Self.Input { get }

    @PortBuilder var output: Self.Output { get }

    func callAsFunction(_ input: Input.Value) -> Output.Value
}

public enum NodeType {
    case input
    case output
    case io
}

public protocol PortProperties {
    var inputPorts: [PortInfo] { get set }
    var outputPorts: [PortInfo] { get set }
}

public struct Node<Input, Output>: Convertible, PortProperties, GeometryProperties, Identifiable {

    public typealias Execution = (_ input: Input) -> Output

    public var type: NodeType = .io

    public var id: String

    public var title: String?

    public var input: PortGroup<Input>

    public var output: PortGroup<Output>

    public var execution: Execution

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public var inputPorts: [PortInfo] {
        get { input.ports }
        set { input.ports = newValue }
    }

    public var outputPorts: [PortInfo] {
        get { output.ports }
        set { output.ports = newValue }
    }

    public init(
        type: NodeType = .io,
        id: String,
        title: String?,
        position: CGPoint = .zero,
        @PortBuilder input: @escaping () -> PortGroup<Input>,
        @PortBuilder output: @escaping  () -> PortGroup<Output>,
        execution: @escaping Execution) {
        self.type = type
        self.id = id
        self.title = title
        self.position = position
        self.input = input()
        self.output = output()
        self.execution = execution
    }

    public func callAsFunction(_ input: Input) -> Output { execution(input) }
}

extension Node {

    subscript(port: Address.Port) -> PortInfo {
        get {
            switch port {
                case .input(let index): return input.ports[index]
                case .output(let index): return output.ports[index]
            }
        }
        set {
            switch port {
                case .input(let index): input.ports[index] = newValue
                case .output(let index): output.ports[index] = newValue
            }
        }
    }
}

extension Node {

    public static func input(
        id: String,
        title: String,
        position: CGPoint,
        @PortBuilder input: @escaping () -> PortGroup<Input>
    ) -> Node where Input == Output {
        Node(type: .input, id: id, title: title, position: position, input: input, output: input, execution: { input in input })
    }

    public static func output(
        id: String,
        title: String,
        position: CGPoint,
        @PortBuilder input: @escaping () -> PortGroup<Input>,
        @PortBuilder output: @escaping  () -> PortGroup<Output>,
        execution: @escaping Execution
    ) -> Node {
        Node(type: .output, id: id, title: title, position: position, input: input, output: output, execution: execution)
    }

    public static func io(
        id: String,
        title: String,
        position: CGPoint,
        @PortBuilder output: @escaping  () -> PortGroup<Output>
    ) -> Node where Input == Output {
        Node(type: .io, id: id, title: title, position: position, input: output, output: output, execution: { output in output })
    }

}

//public enum NodeType {
//    case input
//    case output
//    case io
//}
//
//public extension Node {
//
//    var inputs: [Port] { ports.filter { $0.type == .input } }
//
//    var outputs: [Port] { ports.filter { $0.type == .output } }
//}
//
//public struct Node: Identifiable, GeomertryProperties {
//
//    public var type: NodeType = .io
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
//    public var ports: [Port] = []
//
//    var execute: ([Port], [Port]) -> [Port.ID: PortData]
//
//    public init(
//        type: NodeType = .io,
//        id: String,
//        title: String,
//        position: CGPoint,
//        ports: [Port] = [],
//        execute: @escaping ([Port], [Port]) -> [Port.ID: PortData]
//    ) {
//        self.type = type
//        self.id = id
//        self.title = title
//        self.position = position
//        self.ports = ports
//        self.execute = execute
//    }
//
//    public subscript(portID: Port.ID) -> Port {
//        get {
//            let index = self.ports.firstIndex(where: { $0.id == portID })!
//            return ports[index]
//        }
//        set {
//            let index = self.ports.firstIndex(where: { $0.id == portID })!
//            ports[index] = newValue
//        }
//    }
//
//    public static func input(
//        id: String,
//        title: String,
//        position: CGPoint,
//        ports: [Port] = []
//    ) -> Node {
//        Node(type: .input, id: id, title: title, position: position, ports: ports) { _, outputs in
//            outputs.reduce([:]) { prev, current in
//                var now = prev
//                now[current.id] = current.data
//                return now
//            }
//        }
//    }
//
//    public static func output(
//        id: String,
//        title: String,
//        position: CGPoint,
//        ports: [Port] = []
//    ) -> Node {
//        Node(type: .output, id: id, title: title, position: position, ports: ports) { _, _ in [:] }
//    }
//}
