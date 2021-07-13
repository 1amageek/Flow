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

    enum DragState {
        case none
        case dragging(CGSize)

        var translaction: CGSize {
            switch self {
                case .none: return .zero
                case .dragging(let value): return value
            }
        }
    }

    var context: Context

    var nodeView: (_ node: Node) -> NodeContent

    var edgeView: (_ edge: Edge) -> EdgeContent

    var connectionView: (_ connection: Connection) -> ConnectionContent

    var offset: CGSize {
        CGSize(
            width: context.canvas.offset.width + dragState.translaction.width,
            height: context.canvas.offset.height + dragState.translaction.height
        )
    }

    var scale: CGFloat { context.canvas.sacle  }

    @State var initialScale: CGFloat = 1

    @State var dragState: DragState = .none

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
                dragState = .dragging(value.translation)
            }
            .onEnded { value in
                dragState = .none
                context.canvas.offset = CGSize(
                    width: context.canvas.offset.width + value.translation.width,
                    height: context.canvas.offset.height + value.translation.height
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
            .coordinateSpace(name: CanvasCoordinateSpace.defaultValue)
            .offset(offset)
            .scaleEffect(scale)
        }
        .contentShape(Rectangle())
        .gesture(SimultaneousGesture(dragGesture, magnificationGesture))
        .environmentObject(context)
        .onDrop(of: [Node.draggableType], isTargeted: nil) { providers, location in
            Node.fromItemProviders(providers) { nodes in
                nodes.forEach { node in
                    var node = node
                    let position = CGPoint(x: location.x - context.canvas.offset.width, y: location.y - context.canvas.offset.height)
                    context.graph.add(node.set(position))
                }
            }
            return true
        }
    }
}

