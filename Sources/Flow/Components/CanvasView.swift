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
    var canvasCoordinateSpace: String { self[CanvasCoordinateSpace.self] }
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

    @Environment(\.undoManager) var undoManager: UndoManager?

    var context: FlowDocument

    var nodeView: (_ node: Node) -> NodeContent

    var edgeView: (_ edge: Edge) -> EdgeContent

    var connectionView: (_ connection: Connection) -> ConnectionContent

    var offset: CGSize {
        CGSize(
            width: context.canvas.offset.width + dragState.translaction.width,
            height: context.canvas.offset.height + dragState.translaction.height
        )
    }

    var scale: CGFloat { context.canvas.scale  }

    @State var initialScale: CGFloat = 1

    @State var dragState: DragState = .none

    public init(_ context: FlowDocument,
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
                context.canvas.scale = initialScale * value
            }
            .onEnded { value in
                initialScale = initialScale * value
            }
    }

    var visibleNodes: [Node] {
        if context.canvas.size == .zero { return [] }
        guard let graph = context.graph else { return [] }
        return graph.nodes.filter { context.canvas.visibleFrame.intersects($0.frame) }
        // TODO: Performance
//        if case .dragging(_) = dragState {
//            return context.cache.nodes ?? []
//        }
//        if let cache = context.cache.nodes {
//            context.visibleNodesTask?.cancel()
//            context.visibleNodesTask = context.visibleNodes { nodes in
//                self.context.cache.nodes = nodes
//            }
//            return cache
//        } else {
//            guard let graph = context.graph else { return [] }
//            let visibleNodes = graph.nodes.filter { context.canvas.visibleFrame.intersects($0.frame) }
//            context.cache.nodes = visibleNodes
//            return visibleNodes
//        }
    }

    var visibleEdges: [Edge] {
        if context.canvas.size == .zero { return [] }
        guard let graph = context.graph else { return [] }
        return graph.edges.filter { edge -> Bool in
            return graph.nodes.contains(where: { $0.id == edge.source.id }) && graph.nodes.contains(where: { $0.id == edge.target.id })
        }
        // TODO: Performance
//        if case .dragging(_) = dragState {
//            return context.cache.edges ?? []
//        }
//        if let cache = context.cache.edges {
//            context.visibleEdgesTask?.cancel()
//            context.visibleEdgesTask = context.visibleEdges { edges in
//                self.context.cache.edges = edges
//            }
//            return cache
//        } else {
//            let nodes = context.cache.nodes ?? []
//            guard let graph = context.graph else { return [] }
//            let visibleEdges = graph.edges.filter { edge -> Bool in
//                return nodes.contains(where: { $0.id == edge.source.id }) && nodes.contains(where: { $0.id == edge.target.id })
//            }
//            context.cache.edges = visibleEdges
//            return visibleEdges
//        }
    }

    func geometryDecide(proxy: GeometryProxy) {
        DispatchQueue.main.async {
            context.canvas.size = proxy.size
        }
    }

    func updateReferenceNode() {
        guard let graph = context.graph else { return }
        DispatchQueue.main.async {
            context.graphs.forEach { targetGraph in
                if graph != targetGraph {
                    targetGraph.nodes.forEach { targetNode in
                        if targetNode.id == graph.id {
                            let newNode = Node.reference(graph.id, id: graph.id, name: graph.name, inputs: graph.inputs, outputs: graph.outputs, position: targetNode.position)
                            context[targetGraph.id]![targetNode.id] = newNode
                        }
                    }
                }
            }
        }
    }

    public var body: some View {
        ZStack {
            if context.canvas.size != .zero {
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GeometryReader { proxy in
            Rectangle()
                .fill(Color.clear)
                .onAppear { geometryDecide(proxy: proxy) }
                .onChange(of: proxy.size ) { _ in geometryDecide(proxy: proxy) }
        })
        .contentShape(Rectangle())
        .gesture(SimultaneousGesture(dragGesture, magnificationGesture))
        .onChange(of: context.graph) { _ in updateReferenceNode() }
        .onDrop(of: [Node.draggableType], isTargeted: nil) { providers, location in
            Node.fromItemProviders(providers) { nodes in
                nodes.forEach { node in
                    var node = node
                    let position = CGPoint(x: location.x - context.canvas.offset.width, y: location.y - context.canvas.offset.height)
                    context.add(node: node.set(position), undoManager: undoManager)
                }
            }
            return true
        }
        .onDisappear { context.dataStore.cache.clear() }
    }
}

