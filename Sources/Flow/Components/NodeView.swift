//
//  NodeView.swift
//
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public struct NodeView<Content: View>: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: FlowDocument

    @Environment(\.undoManager) var undoManager

    var node: Node

    var id: Node.ID { node.id }

    var cornerRadius: CGFloat = 12

    var position: CGPoint { context.graph?.nodes[id]?.position ?? .zero  }

    var offset: CGSize { context.graph?.nodes[id]?.offset ?? .zero  }

    var gesture: some Gesture {
        DragGesture(minimumDistance: 0.2)
            .onChanged { value in
                context.graph?.nodes[id]?.offset = value.translation
            }
            .onEnded { value in
                let position = context.nodes[id]?.position ?? .zero
                context.graph?.nodes[id]?.offset = .zero
                context.graph?.nodes[id]?.position = CGPoint(
                    x: position.x + value.translation.width,
                    y: position.y + value.translation.height
                )
            }
    }

    var content: ([Port], [Port]) -> Content

    public init(_ node: Node, content: @escaping ([Port], [Port]) -> Content) {
        self.node = node
        self.content = content
    }

    func geometryDecide(proxy: GeometryProxy) {
        DispatchQueue.main.async {
            context.graph?.nodes[id]?.size = proxy.size
        }
    }

    public var body: some View {
        content(node.inputs, node.outputs)
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear { geometryDecide(proxy: proxy) }
                    .onChange(of: proxy.size ) { _ in geometryDecide(proxy: proxy) }
            })
            .coordinateSpace(name: id)
            .position(position)
            .offset(offset)
            .gesture(gesture)
            .onTapGesture { context.focusNode = context.nodes[id] }
            .onAppear {
                if case .reference(_) = node.type {
                    if let graph = context.graphs[node.id] {
                        let newNode = Node.reference(graph.id, id: graph.id, name: graph.name, inputs: graph.inputs, outputs: graph.outputs)
                        context.replace(node: newNode, undoManager: undoManager)
                    } else {
                        context.delete(node: node, undoManager: undoManager)
                    }
                }
            }
    }
}

