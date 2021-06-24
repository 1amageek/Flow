//
//  NodeView.swift
//  
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

struct Jack: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    @State var isHover: Bool = false

    var node: Node

    var port: Port

    init(node: Node, port: Port) {
        self.node = node
        self.port = port
    }

    func gesture(proxy: GeometryProxy) -> some Gesture {
        DragGesture(coordinateSpace: .named(canvasCoordinateSpace))
            .onChanged { value in
                let frame = proxy.frame(in: .named(canvasCoordinateSpace))
                let start = CGPoint(
                    x: frame.origin.x + frame.width / 2,
                    y: frame.origin.y + frame.height / 2
                )
                let end = value.location
                if context.connecting != nil {
                    context.connecting?.end = end
                } else {
                    context.connecting = Connection(
                        id: node.id,
                        start: start,
                        end: end,
                        startAddress: Address(nodeID: node.id, portID: port.id)
                    )
                }
            }
            .onEnded { value in
                if var connection = context.connecting {
                    let address = context.address(at: value.location)
                    connection.endAddress = address
                    let edge = context.edge(from: connection)
                }

                context.connecting = nil
            }
    }

    var body: some View {
        GeometryReader { proxy in
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
                    .onAppear {
                        let size = proxy.size
                        let frame = proxy.frame(in: .named(node.id))
                        let frameOnCanvas = proxy.frame(in: .named(canvasCoordinateSpace))
                        context.nodeGeometories[node.id]?.ports[port.id]?.size = size
                        context.nodeGeometories[node.id]?.ports[port.id]?.frame = frame
                        context.nodeGeometories[node.id]?.ports[port.id]?.frameOnCanvas = frameOnCanvas
                    }
            }
            .contentShape(Circle())
            .gesture(gesture(proxy: proxy))
        }
        .frame(width: 20, height: 20)
        .hoverEffect()
    }
}

struct InputJack: View {

    var node: Node

    var port: Port

    var value: String

    var body: some View {
        HStack {
            Jack(node: node, port: port)
            Text(port.title)
            Text(value)
        }
    }
}

struct OutputJack: View {

    var node: Node

    var port: Port

    var value: String

    var body: some View {
        HStack {
            Text(value)
            Text(port.title)
            Jack(node: node, port: port)
        }
    }
}

public struct NodeView: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    var node: Node

    var cornerRadius: CGFloat = 12

    var position: CGPoint { context.nodeGeometories[node.id]?.position ?? .zero  }

    var offset: CGSize { context.nodeGeometories[node.id]?.offset ?? .zero  }

    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                context.nodeGeometories[node.id]?.offset = value.translation
            }
            .onEnded { value in
                let position = context.nodeGeometories[node.id]?.position ?? .zero
                context.nodeGeometories[node.id]?.offset = .zero
                context.nodeGeometories[node.id]?.position = CGPoint(
                    x: position.x + value.translation.width,
                    y: position.y + value.translation.height
                )
            }
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text(node.title)
                .padding(8)
            HStack(spacing: 8) {
                VStack {
                    ForEach(node.inputs) { port in
                        InputJack(node: node, port: port, value: "\(0)")
                    }
                }
                Spacer()
                VStack {
                    ForEach(node.outputs) { port in
                        OutputJack(node: node, port: port, value: "\(0)")
                    }
                }
            }.padding(8)
        }
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.black, lineWidth: 4)
        )
        .overlay(
            context.focusNode?.id == node.id ?
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.blue, lineWidth: 4) : nil
        )
        .frame(width: 260, alignment: .center)
        .background(GeometryReader { proxy in
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white)
                .onAppear {
                    let frame = proxy.frame(in: .named(canvasCoordinateSpace))
                    context.nodeGeometories[node.id]?.frame = frame
                    context.nodeGeometories[node.id]?.size = proxy.size
                }
        })
        .onTapGesture {
            self.context.focusNode = node
        }
        .position(position)
        .offset(offset)
        .gesture(gesture)
        .padding(6)
        .coordinateSpace(name: node.id)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(node: Node(id: "0", title: "Function"))
            .environmentObject(CanvasContext())
    }
}
