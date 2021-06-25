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

public struct CanvasView: View {

    @ObservedObject public var canvasContext: CanvasContext = CanvasContext(
        nodes: [
            Node(id: "0", title: "0", position: CGPoint(x: 100, y: 100), inputs: [InputPort(id: "0", title: "Input")], outputs: [OutputPort(id: "1", title: "Output")]),
            Node(id: "1", title: "1", position: CGPoint(x: 100, y: 200), inputs: [InputPort(id: "0", title: "Input")], outputs: [OutputPort(id: "1", title: "Output")])
        ],
        edges: [
            Edge(id: "0", source: Address(nodeID: "0", portID: "0"), target: Address(nodeID: "1", portID: "1"))
        ]
    )

    public init() {
        
    }

    public var body: some View {
        ZStack {
            ForEach(canvasContext.nodes) { node in
                NodeView(node: node)
            }
            ForEach(canvasContext.edges) { edge in
                EdgeView(edge: edge)
            }
            if let connnection = canvasContext.connecting {
                ConnectionView(connection: connnection)
            }
        }
        .onTapGesture {
            canvasContext.focusNode = nil
        }
        .environmentObject(canvasContext)
        .coordinateSpace(name: CanvasCoordinateSpace.defaultValue)

    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
