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

public struct CanvasView<NodeContent: View, EdgeContent: View, ConnectionContent: View>: View {

    var graph: Graph

    var nodeView: (_ node: Node) -> NodeContent

    var edgeView: (_ edge: Edge) -> EdgeContent

    var connectionView: (_ connection: Connection) -> ConnectionContent

    var position: CGPoint { graph.canvas.position  }

    var offset: CGSize { graph.canvas.offset }

    public init(_ graph: Graph,
                @ViewBuilder nodeView: @escaping (_ node: Node) -> NodeContent,
                @ViewBuilder edgeView: @escaping (_ edge: Edge) -> EdgeContent,
                @ViewBuilder connectionView: @escaping (_ connection: Connection) -> ConnectionContent
    ) {
        self.graph = graph
        self.nodeView = nodeView
        self.edgeView = edgeView
        self.connectionView = connectionView
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
                    nodeView(node)
                }
                ForEach(graph.edges) { edge in
                    edgeView(edge)
                }
                if let connnection = graph.connecting {
                    connectionView(connnection)
                }
            }
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear { graph.canvas.position = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2) }
                    .onChange(of: proxy.size ) { newValue in graph.canvas.position = CGPoint(x: newValue.width / 2, y: newValue.height / 2) }
            })
            .coordinateSpace(name: CanvasCoordinateSpace.defaultValue)
            .position(position)
            .offset(offset)
        }
        .contentShape(Rectangle())
        .gesture(gesture)
        .environmentObject(graph)
    }
}
