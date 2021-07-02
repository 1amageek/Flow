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
            .input(id: "R", title: "R", position: CGPoint(x: 200, y: 200), inputs: [Interface()]),
            .input(id: "G", title: "G", position: CGPoint(x: 200, y: 400), inputs: [Interface()]),
            .input(id: "B", title: "B", position: CGPoint(x: 200, y: 600), inputs: [Interface()]),
            .io(id: "RGB", title: "RGB", position: CGPoint(x: 400, y: 400), inputs: [Interface(), Interface(), Interface()], outputs: [Interface()])
//            Node.input(id: "A", title: "A", position: CGPoint(x: 200, y: 200), input: , output: ,
//            Node.input(id: "B", title: "B", position: CGPoint(x: 200, y: 400), ports: [.output(id: "0", title: "Output", data: .float(4))]),
//            Node.io(id: "SUM", title: "SUM", position: CGPoint(x: 490, y: 200),
//                 ports: [
//                    .input(id: "0", title: "A"),
//                    .input(id: "1", title: "B"),
//                    .output(id: "2", title: "Output")
//                 ], execute: sum),
//            Node.output(id: "RESULT", title: "RESULT", position: CGPoint(x: 790, y: 200), ports: [.input(id: "0", title: "Input", data: .string("sss"))])
        ],
        edges: [
//            Edge(id: "0", source: Address(id: "R", port: .output(0)), target: Address(id: "RGB", port: .output(0))),
//            Edge(id: "1", source: Address(nodeID: "B", portID: "0"), target: Address(nodeID: "SUM", portID: "1")),
//            Edge(id: "2", source: Address(nodeID: "SUM", portID: "2"), target: Address(nodeID: "RESULT", portID: "0")),
        ]
    )

    func inputNode(node: Node) -> some View {
        HStack(spacing: 16) {
            VStack {
                ForEach(node.outputs) { port in
                    HStack(alignment: .center, spacing: 8) {
//                        TextField("0", text: $graph[node.id][port.id].text)
//                            .frame(width: 120)
                        Circle()
                            .frame(width: 8, height: 8)
                            .port(.output(node.id, index: port.id))
                    }
                }
            }
        }
        .padding(8)
    }

    func outputNode(node: Node) -> some View {
        HStack(spacing: 16) {
            VStack {
                ForEach(node.inputs) { port in
                    HStack(alignment: .center, spacing: 8) {
                        Circle()
                            .frame(width: 8, height: 8)
                            .port(.input(node.id, index: port.id))
//                        if let data = graph.data(node: node, port: port) {
//                            Text(data.text)
//                        }
                    }
                }
            }
        }
        .padding(8)
    }


    var body: some View {
        CanvasView(graph) { node in
            NodeView(node) { inputs, outputs in
                VStack {
                    Text(node.title ?? "").bold()
                    if node.type == .input {
                        inputNode(node: node)
                    } else if node.type == .output {
                        outputNode(node: node)
                    } else {
                        HStack(spacing: 16) {
                            VStack {
                                ForEach(inputs) { port in
                                    HStack(alignment: .center, spacing: 8) {
                                        Circle()
                                            .frame(width: 8, height: 8)
                                            .port(.input(node.id, index: port.id))
                                        Text(port.title ?? "")
//                                        if let data = graph.data(node: node, port: port) {
//                                            Text(data.text)
//                                        }
                                    }
                                }
                            }
                            VStack {
                                ForEach(outputs) { port in
                                    HStack(alignment: .center, spacing: 8) {
                                        Text(port.title ?? "")
//                                        if let data = graph.data(node: node, port: port) {
//                                            Text(data.text )
//                                        }
                                        Circle()
                                            .frame(width: 8, height: 8)
                                            .port(.output(node.id, index: port.id))
                                    }
                                }
                            }
                        }
                        .padding(8)
                    }
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
