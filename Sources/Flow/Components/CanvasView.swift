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

    var context: Context

    var nodeView: (_ node: Node) -> NodeContent

    var edgeView: (_ edge: Edge) -> EdgeContent

    var connectionView: (_ connection: Connection) -> ConnectionContent

    var position: CGPoint { context.canvas.position  }

    var offset: CGSize { context.canvas.offset }

    var scale: CGFloat { context.canvas.sacle  }

    @State var initialScale: CGFloat = 1

    public init(_ context: Context,
                @ViewBuilder nodeView: @escaping (_ node: Node) -> NodeContent,
                @ViewBuilder edgeView: @escaping (_ edge: Edge) -> EdgeContent,
                @ViewBuilder connectionView: @escaping (_ connection: Connection) -> ConnectionContent,
                shouldConnectNode: @escaping (_ nodes: [Node], _ edges: [Edge], _ connection: Connection) -> Bool = { _, _, _ in true }
    ) {
        self.context = context
        self.nodeView = nodeView
        self.edgeView = edgeView
        self.connectionView = connectionView
        if self.context.shouldConnectNodeHandler == nil {
            self.context.shouldConnectNodeHandler = shouldConnectNode
        }
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0.15)
            .onChanged { value in
                context.canvas.offset = value.translation
            }
            .onEnded { value in
                let position = context.canvas.position
                context.canvas.offset = .zero
                context.canvas.position = CGPoint(
                    x: position.x + value.translation.width,
                    y: position.y + value.translation.height
                )
            }
    }

    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                context.canvas.sacle = initialScale * value
            }
            .onEnded { value in
                initialScale = initialScale * value
            }
    }

    public var body: some View {
        ZStack {
            ZStack {
                ForEach(context.graph.nodes) { node in
                    nodeView(node)
                }
                ForEach(context.graph.edges) { edge in
                    edgeView(edge)
                }
                if let connnection = context.connecting {
                    connectionView(connnection)
                }
            }
            .background(GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear { context.canvas.position = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2) }
                    .onChange(of: proxy.size ) { newValue in context.canvas.position = CGPoint(x: newValue.width / 2, y: newValue.height / 2) }
            })
            .coordinateSpace(name: CanvasCoordinateSpace.defaultValue)
            .position(position)
            .offset(offset)
            .scaleEffect(scale)
        }
        .contentShape(Rectangle())
        .gesture(SimultaneousGesture(dragGesture, magnificationGesture))
        .environmentObject(context)
    }
}

