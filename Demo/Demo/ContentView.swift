//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2021/06/21.
//

import SwiftUI
import Flow

struct ContentView: View {

    @ObservedObject public var graph: Graph = Graph(
        nodes: [
            IONode.input(id: "A", title: "A", position: CGPoint(x: 200, y: 200), outputs: [OutputPort(id: "0", title: "Output", data: .int(0))]),
            IONode.input(id: "B", title: "B", position: CGPoint(x: 200, y: 400), outputs: [OutputPort(id: "0", title: "Output", data: .int(0))]),
            IONode(id: "SUM", title: "SUM", position: CGPoint(x: 490, y: 200),
                   inputs: [InputPort(id: "0", title: "A", data: .int(3)), InputPort(id: "1", title: "B", data: .int(3))],
                   outputs: [OutputPort(id: "0", title: "Output", data: .int(3))]) { _ in [] },
            IONode.output(id: "RESULT", title: "RESULT", position: CGPoint(x: 790, y: 200), inputs: [InputPort(id: "0", title: "Input", data: .string("sss"))])
        ],
        edges: [
            Edge(id: "0", source: Address(nodeID: "A", portID: "0"), target: Address(nodeID: "SUM", portID: "0")),
            Edge(id: "1", source: Address(nodeID: "B", portID: "0"), target: Address(nodeID: "SUM", portID: "1")),
            Edge(id: "2", source: Address(nodeID: "SUM", portID: "0"), target: Address(nodeID: "RESULT", portID: "0")),
        ]
    )

    var body: some View {
        CanvasView(graph) { node in
            NodeView(node: node) { inputs, outputs in
                VStack {
                    Text(node.title).bold()
                    HStack(spacing: 16) {
                        VStack {
                            ForEach(inputs) { port in
                                HStack(alignment: .center, spacing: 8) {
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .inputPort(node: node, port: port)
                                    Text(port.title)
                                    if node.type == .output {
                                        Text(port.value)
                                    }
                                }
                            }
                        }
                        VStack {
                            ForEach(outputs) { port in
                                HStack(alignment: .center, spacing: 8) {
                                    Text(port.title)
                                    Text(port.value)
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .outputPort(node: node, port: port)
                                }
                            }
                        }
                    }
                    .padding(8)
                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .clipped()
                .shadow(radius: 4)
            }
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
