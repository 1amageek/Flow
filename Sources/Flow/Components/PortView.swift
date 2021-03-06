//
//  PortView.swift
//  
//
//  Created by nori on 2021/06/24.
//

import SwiftUI

public struct InputPortView<Content: View>: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: FlowDocument

    @Environment(\.undoManager) var undoManager

    public var id: String

    public var portIndex: PortIndex

    var value: String

    var content: () -> Content

    public init(id: String, portIndex: PortIndex, value: String, content: @escaping () -> Content) {
        self.id = id
        self.portIndex = portIndex
        self.value = value
        self.content = content
    }

    func geometryDecide(proxy: GeometryProxy) {
        DispatchQueue.main.async {
            if context.graph?.nodes[id]?.inputs.exist(portIndex) ?? false {
                let frame = proxy.frame(in: .named(id))
                context.graph?.nodes[id]?[.input(portIndex)]?.size = proxy.size
                context.graph?.nodes[id]?[.input(portIndex)]?.position = CGPoint(
                    x: frame.origin.x + proxy.size.width / 2,
                    y: frame.origin.y + proxy.size.height / 2
                )
            }
        }
    }

    public var body: some View {
        content()
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear { geometryDecide(proxy: proxy) }
                    .onChange(of: proxy.frame(in: .named(id))) { _ in geometryDecide(proxy: proxy) }
                    .onChange(of: context.graph?.nodes[id]?.inputs.count) { _ in geometryDecide(proxy: proxy) }
                    .onChange(of: context.graph?.nodes[id]?.outputs.count) { _ in geometryDecide(proxy: proxy) }
            })
            .modifier(JackModifier(id: id, portIndex: portIndex, onConnecting: { value in
                if context.connecting != nil {
                    context.connecting?.end = value.location
                    context.connecting?.endAddress = context.outputPortAddress(at: value.location)
                } else {
                    let address: Address = .input(id, index: portIndex)
                    if let edge = context.edges.filter({ $0.target == .input(id, index: portIndex) }).first {
                        context.graph?.edges[edge.id] = nil
                        context.connecting = Connection(
                            id: id,
                            start: context.position(with: edge.source) ?? .zero,
                            end: value.location,
                            startAddress: edge.source
                        )
                    } else {
                        context.connecting = Connection(
                            id: id,
                            start: context.position(with: address) ?? .zero,
                            end: value.location,
                            startAddress: address
                        )
                    }
                }
            }, onConnected: { value in
                if var connection = context.connecting {
                    guard let address = context.outputPortAddress(at: value.location) else { return }
                    connection.endAddress = address
                    if context.shouldConnect(connection) {
                        let edge = Edge(source: address, target: connection.startAddress)
                        context.add(edge: edge, undoManager: undoManager)
                    }
                }
            }))
    }
}

public struct OutputPortView<Content: View>: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: FlowDocument

    @Environment(\.undoManager) var undoManager

    public var id: String

    public var portIndex: PortIndex

    var value: String

    var content: () -> Content

    public init(id: String, portIndex: Int, value: String, content: @escaping () -> Content) {
        self.id = id
        self.portIndex = portIndex
        self.value = value
        self.content = content
    }

    func geometryDecide(proxy: GeometryProxy) {
        DispatchQueue.main.async {
            if context.graph?.nodes[id]?.outputs.exist(portIndex) ?? false {
                let frame = proxy.frame(in: .named(id))
                context.graph?.nodes[id]?[.output(portIndex)]?.size = proxy.size
                context.graph?.nodes[id]?[.output(portIndex)]?.position = CGPoint(
                    x: frame.origin.x + proxy.size.width / 2,
                    y: frame.origin.y + proxy.size.height / 2
                )
            }
        }
    }

    public var body: some View {
        content()
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear { geometryDecide(proxy: proxy) }
                    .onChange(of: proxy.frame(in: .named(id))) { _ in geometryDecide(proxy: proxy) }
                    .onChange(of: context.graph?.nodes[id]?.inputs.count) { _ in geometryDecide(proxy: proxy) }
                    .onChange(of: context.graph?.nodes[id]?.outputs.count) { _ in geometryDecide(proxy: proxy) }
            })
            .modifier(JackModifier(id: id, portIndex: portIndex, onConnecting: { value in
                if context.connecting != nil {
                    context.connecting?.end = value.location
                    context.connecting?.endAddress = context.inputPortAddress(at: value.location)
                } else {
                    let address: Address = .output(id, index: portIndex)
                    context.connecting = Connection(
                        id: id,
                        start: context.position(with: address) ?? .zero,
                        end: value.location,
                        startAddress: address
                    )
                }
            }, onConnected: { value in
                if var connection = context.connecting {
                    guard let address = context.inputPortAddress(at: value.location) else { return }
                    connection.endAddress = address
                    if context.shouldConnect(connection) {
                        let edge = Edge(source: connection.startAddress, target: address)
                        context.add(edge: edge, undoManager: undoManager)
                    }
                }
            }))
    }
}

struct JackModifier: ViewModifier {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: FlowDocument

    var id: String

    var portIndex: Int

    var onConnectingHandler: (DragGesture.Value) -> Void

    var onConnectedHandler: (DragGesture.Value) -> Void

    init(
        id: String,
        portIndex: Int,
        onConnecting: @escaping (DragGesture.Value) -> Void,
        onConnected: @escaping (DragGesture.Value) -> Void
    ) {
        self.id = id
        self.portIndex = portIndex
        self.onConnectingHandler = onConnecting
        self.onConnectedHandler = onConnected
    }

    var gesture: some Gesture {
        DragGesture(minimumDistance: 0.2, coordinateSpace: .named(canvasCoordinateSpace))
            .onChanged { value in onConnectingHandler(value) }
            .onEnded { value in
                onConnectedHandler(value)
                context.connecting = nil
            }
    }

    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}


struct InputPortModifier: ViewModifier {

    var id: String

    var portIndex: PortIndex

    init(id: String, portIndex: PortIndex) {
        self.id = id
        self.portIndex = portIndex
    }

    func body(content: Content) -> some View {
        InputPortView<Content>(id: id, portIndex: portIndex, value: "") { content }
    }
}

struct OutputPortModifier: ViewModifier {

    var id: String

    var portIndex: PortIndex

    init(id: String, portIndex: PortIndex) {
        self.id = id
        self.portIndex = portIndex
    }

    func body(content: Content) -> some View {
        OutputPortView<Content>(id: id, portIndex: portIndex, value: "") { content }
    }
}

extension View {

    @ViewBuilder
    public func port(_ address: Address) -> some View {
        switch address.port {
            case .input(let index):
                self.modifier(InputPortModifier(id: address.id, portIndex: index))
            case .output(let index):
                self.modifier(OutputPortModifier(id: address.id, portIndex: index))
        }
    }
}
