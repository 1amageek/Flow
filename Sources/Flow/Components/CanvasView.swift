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

    var content: (Node) -> Content

    public init(_ graph: Graph, @ViewBuilder content: @escaping (Node) -> Content) {
        self.graph = graph
        self.content = content
    }

    public var body: some View {
//        ScrollView([.vertical, .horizontal], showsIndicators: true) {
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
//        }
//        .background(Color.red)
        .onTapGesture {
            graph.focusNode = nil
        }
        .environmentObject(graph)
        .coordinateSpace(name: CanvasCoordinateSpace.defaultValue)
    }
}

//struct CanvasView_Previews: PreviewProvider {
//    static var previews: some View {
//        CanvasView(
//            nodes: [
//                Node(id: "0", title: "0", position: CGPoint(x: 100, y: 100), inputs: [InputPort(id: "0", title: "Input")], outputs: [OutputPort(id: "1", title: "Output")]),
//                Node(id: "1", title: "1", position: CGPoint(x: 100, y: 200), inputs: [InputPort(id: "0", title: "Input")], outputs: [OutputPort(id: "1", title: "Output")])
//            ],
//            edges: [
//                Edge(id: "0", source: Address(nodeID: "0", portID: "0"), target: Address(nodeID: "1", portID: "1"))
//            ]
//        ) { node in
//            NodeView(node: node) { inputs, outputs in
//                VStack {
//                    HStack(spacing: 8) {
//                        VStack {
//                            ForEach(inputs) { port in
//                                HStack {
//                                    InputPortView(node: node, port: port, value: "\(0)") {
//                                        Circle()
//                                    }
//                                    Text(port.title)
//                                }
//                            }
//                        }
//                        VStack {
//                            ForEach(outputs) { port in
//                                HStack {
//                                    Text(port.title)
//                                    OutputPortView(node: node, port: port, value: "\(0)") {
//                                        Circle()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .padding(8)
//                }
//            }
//        }
//    }
//}
