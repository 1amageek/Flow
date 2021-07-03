//
//  CanvasView.swift
//  
//
//  Created by nori on 2021/06/21.
//

import SwiftUI

private struct CanvasCoordinateSpace: EnvironmentKey {
    static var defaultValue: String = "CoordinateSpace.Canvas"
}

extension EnvironmentValues {
    var canvasCoordinateSpace: String { self[CanvasCoordinateSpace] }
}

public struct CanvasView<Content: View>: View {

    var graph: Graph

    var content: (_ node: Node) -> Content

    var position: CGPoint { graph.canvas.position  }

    var offset: CGSize { graph.canvas.offset }

    public init(_ graph: Graph, @ViewBuilder content: @escaping (_ id: Node) -> Content) {
        self.graph = graph
        self.content = content
    }

    var gesture: some Gesture {
        DragGesture(minimumDistance: 0.15)
            .onChanged { value in
                graph.canvas.offset = value.translation
            }
            .onEnded { value in
                let position = graph.canvas.position
                graph.canvas.offset = .zero
                graph.canvas.position = CGPoint(
                    x: position.x + value.translation.width,
                    y: position.y + value.translation.height
                )
            }
    }

    public var body: some View {
        ZStack {
            ZStack {
                ForEach(graph.nodes) { node in
                    content(node)
                }
                ForEach(graph.edges) { edge in
                    EdgeView(edge: edge)
                }
                if let connnection = graph.connecting {
                    ConnectionView(connection: connnection)
                }
            }
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear { graph.canvas.position = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2) }
                    .onChange(of: proxy.size ) { newValue in graph.canvas.position = CGPoint(x: newValue.width / 2, y: newValue.height / 2) }
            })
            .position(position)
            .offset(offset)
        }
        .coordinateSpace(name: CanvasCoordinateSpace.defaultValue)
        .contentShape(Rectangle())
        .gesture(gesture)
        .onTapGesture {
            graph.focusNode = nil
        }
        .environmentObject(graph)

    }
}
