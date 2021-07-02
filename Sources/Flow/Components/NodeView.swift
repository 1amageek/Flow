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

    var id: String

    var cornerRadius: CGFloat = 12

    var position: CGPoint { context.nodes[id]?.position ?? .zero  }

    var offset: CGSize { context.nodes[id]?.offset ?? .zero  }

    var gesture: some Gesture {
        DragGesture(minimumDistance: 0.1)
            .onChanged { value in
                context.nodes[id]?.offset = value.translation
            }
            .onEnded { value in
                let position = context.nodes[id]?.position ?? .zero
                context.nodes[id]?.offset = .zero
                context.nodes[id]?.position = CGPoint(
                    x: position.x + value.translation.width,
                    y: position.y + value.translation.height
                )
            }
    }

    var content: ([String], [String]) -> Content

    var inputIDs: [String] { context.nodes[id]?.input.ports.enumerated().map { "\($0)" } ?? [] }

    var outputIDs: [String] { context.nodes[id]?.output.ports.enumerated().map { "\($0)" } ?? [] }

    public init(_ id: String, content: @escaping ([String], [String]) -> Content) {
        self.id = id
        self.content = content
    }

    public var body: some View {
        content(inputIDs, outputIDs)
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear { context.nodes[id]?.size = proxy.size }
            })
            .coordinateSpace(name: id)
            .position(position)
            .offset(offset)
            .simultaneousGesture(gesture)
            .onTapGesture { context.focusNode = context.nodes[id] }
    }
}

