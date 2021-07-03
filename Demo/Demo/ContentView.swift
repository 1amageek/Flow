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
            .input(id: "R", title: "R", position: CGPoint(x: 200, y: 200), inputs: [.float()]),
            .input(id: "G", title: "G", position: CGPoint(x: 200, y: 400), inputs: [.float()]),
            .input(id: "B", title: "B", position: CGPoint(x: 200, y: 600), inputs: [.float()]),
            .io(id: "RGB", title: "RGB", position: CGPoint(x: 400, y: 400), inputs: [.float(), .float(), .float()], outputs: [])
        ],
        edges: [
            Edge(source: .output("R", index: 0), target: .input("RGB", index: 0)),
            Edge(source: .output("G", index: 0), target: .input("RGB", index: 1)),
            Edge(source: .output("B", index: 0), target: .input("RGB", index: 2))
        ]
    )

    func inputNode(node: Node) -> some View {
        HStack(spacing: 16) {
            VStack {
                ForEach(node.inputs) { port in
                    HStack(alignment: .center, spacing: 8) {
                        TextField("0", text: $graph[node.id][.input(port.id)].text)
                            .frame(width: 40)
                            .padding(2)
                    }
                }
            }
            VStack {
                ForEach(node.outputs) { port in
                    HStack(alignment: .center, spacing: 8) {
                        if let data = graph.data(for: port.address) {
                            Text(data.text)
                        }
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
                        if let data = graph.data(for: port.address) {
                            Text(data.text)
                        }
                    }
                }
            }
        }
        .padding(8)
    }

    var backgroundColor: Color {
        return Color(
            .sRGB,
            red: Double(graph.data(for: .input("R", index: 0)).floatValue ?? 0),
            green: Double(graph.data(for: .input("G", index: 0)).floatValue ?? 0),
            blue: Double(graph.data(for: .input("B", index: 0)).floatValue ?? 0),
            opacity: 1
        )
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
                                            .port(port.address)
                                        Text(port.title ?? "")
                                        if let data = graph.data(for: port.address) {
                                            Text(data.text)
                                        }
                                    }
                                }
                            }
                            VStack {
                                ForEach(outputs) { port in
                                    HStack(alignment: .center, spacing: 8) {
                                        Text(port.title ?? "")
                                        if let data = graph.data(for: port.address) {
                                            Text(data.text)
                                        }
                                        Circle()
                                            .frame(width: 8, height: 8)
                                            .port(port.address)
                                    }
                                }
                            }
                        }
                        .padding(8)
                        .background(backgroundColor)
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
