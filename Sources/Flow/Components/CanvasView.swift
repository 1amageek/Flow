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

    var scale: CGFloat { graph.canvas.sacle  }

    @State var initialScale: CGFloat = 1

    public init(_ graph: Graph,
                @ViewBuilder nodeView: @escaping (_ node: Node) -> NodeContent,
                @ViewBuilder edgeView: @escaping (_ edge: Edge) -> EdgeContent,
                @ViewBuilder connectionView: @escaping (_ connection: Connection) -> ConnectionContent,
                shouldConnectNode: @escaping (_ nodes: [Node], _ edges: [Edge], _ connection: Connection) -> Bool = { _, _, _ in true }
    ) {
        self.graph = graph
        self.nodeView = nodeView
        self.edgeView = edgeView
        self.connectionView = connectionView
        if self.graph.shouldConnectNodeHandler == nil {
            self.graph.shouldConnectNodeHandler = shouldConnectNode
        }
    }

    var dragGesture: some Gesture {
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

    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                graph.canvas.sacle = initialScale * value
            }
            .onEnded { value in
                initialScale = initialScale * value
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
            .scaleEffect(scale)
        }
        .contentShape(Rectangle())
        .gesture(SimultaneousGesture(dragGesture, magnificationGesture))
        .environmentObject(graph)
    }
}

