//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2021/06/21.
//

import SwiftUI
import Flow

struct ContentView: View {
    var body: some View {
        CanvasView(
            nodes: [
                Node(id: "0", title: "0", position: CGPoint(x: 100, y: 100), inputs: [InputPort(id: "0", title: "Input")], outputs: [OutputPort(id: "1", title: "Output")]),
                Node(id: "1", title: "1", position: CGPoint(x: 100, y: 200), inputs: [InputPort(id: "0", title: "Input")], outputs: [OutputPort(id: "1", title: "Output")])
            ],
            edges: [
                Edge(id: "0", source: Address(nodeID: "0", portID: "0"), target: Address(nodeID: "1", portID: "1"))
            ]
        ) { node in
            NodeView(node: node) { inputs, outputs in
                VStack {
                    HStack(spacing: 8) {
                        VStack {
                            ForEach(inputs) { port in
                                HStack(alignment: .center, spacing: 4) {
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .inputPort(node: node, port: port)
                                    Text(port.title)
                                }
                            }
                        }
                        VStack {
                            ForEach(outputs) { port in
                                HStack(alignment: .center, spacing: 4) {
                                    Text(port.title)
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .outputPort(node: node, port: port)
                                }
                            }
                        }
                    }
                    .padding(8)
                }
                .background(Color.white)
                .clipped()
                .shadow(radius: 8)
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
