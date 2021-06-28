//
//  SwiftUIView.swift
//  
//
//  Created by nori on 2021/06/24.
//

import SwiftUI

public protocol PortView: View {

    associatedtype Port

    var node: Node { get }

    var port: Port { get }
}

public struct InputPortView<Content: View>: PortView {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    public var node: Node

    public var port: InputPort

    var value: String

    var content: () -> Content

    public init(node: Node, port: InputPort, value: String, content: @escaping () -> Content) {
        self.node = node
        self.port = port
        self.value = value
        self.content = content
    }

    public var body: some View {
        content()
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear {
                        let frame = proxy.frame(in: .named(node.id))
                        context.nodes[node.id]?.inputs[port.id]?.size = proxy.size
                        context.nodes[node.id]?.inputs[port.id]?.position = CGPoint(
                            x: frame.origin.x + proxy.size.width / 2,
                            y: frame.origin.y + proxy.size.height / 2
                        )
                    }
            })
            .modifier(JackModifier(node: node, port: port,
                                   onConnecting: { value in
                context.connecting = Connection(
                    id: node.id,
                    start: context.position(at: node, port: port) ?? .zero,
                    end: value.location,
                    startAddress: Address(nodeID: node.id, portID: port.id)
                )
            }, onConnected: { value in
                if var connection = context.connecting {
                    guard let address = context.outputPortAddress(at: value.location) else { return }
                    connection.endAddress = address
                    let edge = Edge(id: UUID().uuidString, source: address, target: connection.startAddress)
                    context.edges.append(edge)
                }
            }))
    }
}

public struct OutputPortView<Content: View>: PortView {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    public var node: Node

    public var port: OutputPort

    var value: String

    var content: () -> Content

    public init(node: Node, port: OutputPort, value: String, content: @escaping () -> Content) {
        self.node = node
        self.port = port
        self.value = value
        self.content = content
    }

    public var body: some View {
        content()
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear {
                        let frame = proxy.frame(in: .named(node.id))
                        context.nodes[node.id]?.outputs[port.id]?.size = proxy.size
                        context.nodes[node.id]?.outputs[port.id]?.position = CGPoint(
                            x: frame.origin.x + proxy.size.width / 2,
                            y: frame.origin.y + proxy.size.height / 2
                        )
                    }
            })
            .modifier(JackModifier(node: node, port: port,
                                   onConnecting: { value in
                context.connecting = Connection(
                    id: node.id,
                    start: context.position(at: node, port: port) ?? .zero,
                    end: value.location,
                    startAddress: Address(nodeID: node.id, portID: port.id)
                )
            }, onConnected: { value in
                if var connection = context.connecting {
                    guard let address = context.inputPortAddress(at: value.location) else { return }
                    connection.endAddress = address
                    let edge = Edge(id: UUID().uuidString, source: connection.startAddress, target: address)
                    context.edges.append(edge)
                }
            }))
    }
}

struct Jack<T: Port, Content: View>: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    @State var isHover: Bool = false

    var node: Node

    var port: T

    var content: () -> Content

    var onConnectingHandler: (DragGesture.Value) -> Void

    var onConnectedHandler: (DragGesture.Value) -> Void

    init(
        node: Node,
        port: T,
        content: @escaping () -> Content,
        onConnecting: @escaping (DragGesture.Value) -> Void,
        onConnected: @escaping (DragGesture.Value) -> Void
    ) {
        self.node = node
        self.port = port
        self.content = content
        self.onConnectingHandler = onConnecting
        self.onConnectedHandler = onConnected
    }

    var gesture: some Gesture {
        DragGesture(coordinateSpace: .named(canvasCoordinateSpace))
            .onChanged { value in
                if context.connecting != nil {
                    context.connecting?.end = value.location
                } else {
                    onConnectingHandler(value)
                }
            }
            .onEnded { value in
                onConnectedHandler(value)
                context.connecting = nil
            }
    }

    var body: some View {
        content()
        .gesture(gesture)
    }
}

struct JackModifier<T: Port>: ViewModifier {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    var node: Node

    var port: T

    var onConnectingHandler: (DragGesture.Value) -> Void

    var onConnectedHandler: (DragGesture.Value) -> Void

    init(
        node: Node,
        port: T,
        onConnecting: @escaping (DragGesture.Value) -> Void,
        onConnected: @escaping (DragGesture.Value) -> Void
    ) {
        self.node = node
        self.port = port
        self.onConnectingHandler = onConnecting
        self.onConnectedHandler = onConnected
    }

    var gesture: some Gesture {
        DragGesture(coordinateSpace: .named(canvasCoordinateSpace))
            .onChanged { value in
                if context.connecting != nil {
                    context.connecting?.end = value.location
                } else {
                    onConnectingHandler(value)
                }
            }
            .onEnded { value in
                onConnectedHandler(value)
                context.connecting = nil
            }
    }

    func body(content:  Content) -> some View {
        content.gesture(gesture)
    }
}


struct InputPortModifier: ViewModifier {

    var node: Node

    var port: InputPort

    init(node: Node, port: InputPort) {
        self.node = node
        self.port = port
    }

    func body(content:  Content) -> some View {
        InputPortView(node: node, port: port, value: "") { content }
    }
}

struct OutputPortModifier: ViewModifier {

    var node: Node

    var port: OutputPort

    init(node: Node, port: OutputPort) {
        self.node = node
        self.port = port
    }

    func body(content:  Content) -> some View {
        OutputPortView(node: node, port: port, value: "") { content }
    }
}

extension View {

    public func inputPort(node: Node, port: InputPort) -> some View {
        return self.modifier(InputPortModifier(node: node, port: port))
    }

    public func outputPort(node: Node, port: OutputPort) -> some View {
        return self.modifier(OutputPortModifier(node: node, port: port))
    }
}
