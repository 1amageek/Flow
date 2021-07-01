//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2021/06/21.
//

import SwiftUI
import Flow

struct ContentView: View {

    static let sum: ([Flow.Port], [Flow.Port]) -> [Flow.Port.ID: PortData] = { inputs, outputs in
        var data: [Flow.Port.ID: PortData] = [:]
        outputs.forEach { output in
            switch output.data {
                case .int(let value):
                    let value: Int = inputs.reduce(0) { (prev, current) in
                        if case .int(let value) = current.data {
                            return prev + value
                        }
                        return prev
                    }
                    return data[output.id] = .int(value)
                case .float(let value):
                    let value: Float = inputs.reduce(0) { (prev, current) in
                        if case .float(let value) = current.data {
                            return prev + value
                        }
                        return prev
                    }
                    return data[output.id] = .float(value)
                default:
                    return data[output.id] = PortData.none
            }
        }
        return data
    }

    @ObservedObject public var graph: Graph = Graph(
        nodes: [
            Node.input(id: "A", title: "A", position: CGPoint(x: 200, y: 200), ports: [.output(id: "0", title: "Output", data: .float(12))]),
            Node.input(id: "B", title: "B", position: CGPoint(x: 200, y: 400), ports: [.output(id: "0", title: "Output", data: .float(4))]),
            Node(id: "SUM", title: "SUM", position: CGPoint(x: 490, y: 200),
                 ports: [
                    .input(id: "0", title: "A"),
                    .input(id: "1", title: "B"),
                    .output(id: "2", title: "Output")
                 ], execute: sum),
            Node.output(id: "RESULT", title: "RESULT", position: CGPoint(x: 790, y: 200), ports: [.input(id: "0", title: "Input", data: .string("sss"))])
        ],
        edges: [
            Edge(id: "0", source: Address(nodeID: "A", portID: "0"), target: Address(nodeID: "SUM", portID: "0")),
            Edge(id: "1", source: Address(nodeID: "B", portID: "0"), target: Address(nodeID: "SUM", portID: "1")),
            Edge(id: "2", source: Address(nodeID: "SUM", portID: "2"), target: Address(nodeID: "RESULT", portID: "0")),
        ]
    )

    @State var text: String = ""

    func inputNode(node: Node) -> some View {
        HStack(spacing: 16) {
            VStack {
                ForEach(node.outputs) { port in
                    HStack(alignment: .center, spacing: 8) {
                        TextField("0", text: $graph[node.id][port.id].text)
                            .frame(width: 120)
                        Circle()
                            .frame(width: 8, height: 8)
                            .outputPort(node: node, port: port)
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
                            .inputPort(node: node, port: port)
                        if let data = graph.data(node: node, port: port) {
                            Text(data.text)
                        }
                    }
                }
            }
        }
        .padding(8)
    }


    var body: some View {
        CanvasView(graph) { node in
            NodeView(node: node) { inputs, outputs in
                VStack {
                    Text(node.title).bold()
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
                                            .inputPort(node: node, port: port)
                                        Text(port.title)
                                        if let data = graph.data(node: node, port: port) {
                                            Text(data.text)
                                        }
                                    }
                                }
                            }
                            VStack {
                                ForEach(outputs) { port in
                                    HStack(alignment: .center, spacing: 8) {
                                        Text(port.title)
                                        if let data = graph.data(node: node, port: port) {
                                            Text(data.text)
                                        }
                                        Circle()
                                            .frame(width: 8, height: 8)
                                            .outputPort(node: node, port: port)
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
