//
//  NodeView.swift
//
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public struct NodeView<Content: View>: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: CanvasContext

    var node: Node

    var cornerRadius: CGFloat = 12

    var position: CGPoint { context.nodes[node.id]?.position ?? .zero  }

    var offset: CGSize { context.nodes[node.id]?.offset ?? .zero  }

    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                context.nodes[node.id]?.offset = value.translation
            }
            .onEnded { value in
                let position = context.nodes[node.id]?.position ?? .zero
                context.nodes[node.id]?.offset = .zero
                context.nodes[node.id]?.position = CGPoint(
                    x: position.x + value.translation.width,
                    y: position.y + value.translation.height
                )
            }
    }

    var content: ([InputPort], [OutputPort]) -> Content

    public init(node: Node, content: @escaping ([InputPort], [OutputPort]) -> Content) {
        self.node = node
        self.content = content
    }

    public var body: some View {
        content(node.inputs, node.outputs)
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear { context.nodes[node.id]?.size = proxy.size }
            })
            .coordinateSpace(name: node.id)
            .position(position)
            .offset(offset)
            .gesture(gesture)
            .onTapGesture { context.focusNode = node }
    }
}

struct NodeView_Previews: PreviewProvider {

    static let node = Node(id: "0", title: "Function", position: .zero)

    static var previews: some View {
        NodeView(node: node) { inputs, outputs in
            HStack(spacing: 8) {
                VStack {
                    ForEach(inputs) { port in
                        InputPortView(node: node, port: port, value: "\(0)") {
                            Circle()
                        }
                    }
                }
                VStack {
                    ForEach(outputs) { port in
                        OutputPortView(node: node, port: port, value: "\(0)") {
                            Circle()
                        }
                    }
                }
            }.padding(8)
        }
            .environmentObject(CanvasContext())
    }
}
