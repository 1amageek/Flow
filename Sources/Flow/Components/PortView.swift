//
//  SwiftUIView.swift
//  
//
//  Created by nori on 2021/06/24.
//

import SwiftUI

struct InputPortView: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    var node: Node

    var port: InputPort

    var value: String

    var body: some View {
        HStack {
            GeometryReader { proxy in
                Jack(node: node, port: port, onConnecting: { value in
                    context.connecting = Connection(
                        id: node.id,
                        start: context.position(at: node, port: port) ?? .zero,
                        end: value.location,
                        startAddress: Address(nodeID: node.id, portID: port.id)
                    )
                }) { value in
                    if var connection = context.connecting {
                        guard let address = context.outputPortAddress(at: value.location) else { return }
                        connection.endAddress = address
                        let edge = Edge(id: UUID().uuidString, source: address, target: connection.startAddress)
                        context.edges.append(edge)
                    }
                }
                    .onAppear {
                        let frame = proxy.frame(in: .named(node.id))
                        print(frame)
                        //                        let frameOnCanvas = proxy.frame(in: .named(canvasCoordinateSpace))
                        context.nodes[node.id]?.inputs[port.id]?.size = proxy.size
                        context.nodes[node.id]?.inputs[port.id]?.position = CGPoint(
                            x: frame.origin.x + proxy.size.width / 2,
                            y: frame.origin.y + proxy.size.height / 2
                        )
                    }
            }
            .frame(width: 20, height: 20)
            Text(port.title)
            Text(value)
        }
    }
}

struct OutputPortView: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    var node: Node

    var port: OutputPort

    var value: String

    var body: some View {
        HStack {
            Text(value)
            Text(port.title)
            GeometryReader { proxy in
                Jack(node: node, port: port, onConnecting: { value in
                    context.connecting = Connection(
                        id: node.id,
                        start: context.position(at: node, port: port) ?? .zero,
                        end: value.location,
                        startAddress: Address(nodeID: node.id, portID: port.id)
                    )
                }) { value in
                    if var connection = context.connecting {
                        guard let address = context.inputPortAddress(at: value.location) else { return }
                        connection.endAddress = address
                        let edge = Edge(id: UUID().uuidString, source: connection.startAddress, target: address)
                        context.edges.append(edge)
                    }
                }
                    .onAppear {
                        let frame = proxy.frame(in: .named(node.id))
                        //                        let frameOnCanvas = proxy.frame(in: .named(canvasCoordinateSpace))
                        context.nodes[node.id]?.outputs[port.id]?.size = proxy.size
                        context.nodes[node.id]?.outputs[port.id]?.position = CGPoint(
                            x: frame.origin.x + proxy.size.width / 2,
                            y: frame.origin.y + proxy.size.height / 2
                        )
                    }
            }
            .frame(width: 20, height: 20)
        }
    }
}

struct Jack<T: Port>: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    @State var isHover: Bool = false

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

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 20, height: 20)
                        .opacity(isHover ? 1 : 0)
                )
                .onHover { isHover in
                    self.isHover = isHover
                }
        }
        .contentShape(Circle())
        .gesture(gesture)
    }
}
