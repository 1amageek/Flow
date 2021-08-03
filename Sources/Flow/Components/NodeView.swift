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

    public var body: some View {
        content(node.inputs, node.outputs)
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear { context.graph?.nodes[id]?.size = proxy.size }
                    .onChange(of: proxy.size ) { newValue in context.graph?.nodes[id]?.size = newValue }
            })
            .coordinateSpace(name: id)
            .position(position)
            .offset(offset)
            .gesture(gesture)
            .onTapGesture { context.focusNode = context.nodes[id] }
    }
}

