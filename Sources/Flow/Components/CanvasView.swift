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

    var visibleNodes: [Node] {
        if context.canvas.size == .zero { return [] }
        return context.graph.nodes.filter { context.canvas.frame.intersects($0.frame) }
    }

    var visibleEdges: [Edge] {
        if context.canvas.size == .zero { return [] }
        return context.graph.edges.filter { edge -> Bool in
            guard let start: CGPoint = context.position(with: edge.source) else { return false }
            guard let end: CGPoint = context.position(with: edge.target) else { return false }
            let minX = min(start.x, end.x)
            let minY = min(start.y, end.y)
            let maxX = max(start.x, end.x)
            let maxY = max(start.y, end.y)
            let width = maxX - minX
            let height = maxY - minY
            let frame: CGRect = CGRect(x: minX, y: minY, width: width, height: height)
            return context.canvas.frame.intersects(frame)
        }
    }

    public var body: some View {
        ZStack {
            ZStack {
                ForEach(visibleNodes) { node in
                    nodeView(node)
                }
                ForEach(visibleEdges) { edge in
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GeometryReader { proxy in
            Rectangle()
                .fill(Color.clear)
                .onAppear { context.canvas.size = proxy.size }
                .onChange(of: proxy.size ) { newValue in context.canvas.size = newValue }
        })
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

