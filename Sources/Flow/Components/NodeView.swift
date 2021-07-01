//
//  NodeView.swift
//
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

public struct NodeView<Content: View>: View {

    @Environment(\.canvasCoordinateSpace) var canvasCoordinateSpace: String

    @EnvironmentObject var context: Graph

    var node: Node

    var cornerRadius: CGFloat = 12

    var position: CGPoint { context.nodes[node.id]?.position ?? .zero  }

    var offset: CGSize { context.nodes[node.id]?.offset ?? .zero  }

    var gesture: some Gesture {
        DragGesture(minimumDistance: 0.1)
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

    var content: ([Port], [Port]) -> Content

    public init(node: Node, content: @escaping ([Port], [Port]) -> Content) {
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
            .simultaneousGesture(gesture)
            .onTapGesture { context.focusNode = node }
    }
}

