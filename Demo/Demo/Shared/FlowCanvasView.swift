//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2021/06/21.
//

import SwiftUI
import Flow

struct FlowCanvasView: View {

    @ObservedObject public var graph: Graph = Graph(
        nodes: [
            .input(id: "R", title: "R", position: CGPoint(x: 200, y: 200), inputs: [.float(title: "R")]),
            .input(id: "G", title: "G", position: CGPoint(x: 200, y: 400), inputs: [.float(title: "B")]),
            .input(id: "B", title: "B", position: CGPoint(x: 200, y: 600), inputs: [.float(title: "B")]),
            .sum(type: .float(0), id: "SUM", title: "SUM", position: CGPoint(x: 400, y: 400), inputs: [.float(), .float(), .float()]),
            .output(id: "OUT", title: "OUT", position: CGPoint(x: 650, y: 400), outputs: [.float()])
        ],
        edges: [
            Edge(source: .output("R", index: 0), target: .input("SUM", index: 0)),
            Edge(source: .output("G", index: 0), target: .input("SUM", index: 1)),
            Edge(source: .output("B", index: 0), target: .input("SUM", index: 2)),
            Edge(source: .output("SUM", index: 0), target: .input("OUT", index: 0)),
        ],
        shouldConnectNode: { _, edges, connection in
        return !edges.contains(where: { $0.target == connection.startAddress || $0.target == connection.endAddress })
    })

    let portSpacing: CGFloat = 24

    @ViewBuilder
    var portCircle: some View {
        Circle()
            .fill(Color(.systemGray2))
            .frame(width: 16, height: 16)
    }

    @ViewBuilder
    func dataText(_ text: String, alignment: Alignment) -> some View {
        Text(text)
            .lineLimit(1)
            .frame(maxWidth: 100, alignment: alignment)
    }

    func inputNode(node: Node) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: portSpacing) {
                ForEach(node.inputs) { port in
                    HStack(alignment: .center, spacing: 8) {
                        TextField("0", text: $graph[node.id][.input(port.id)].text)
                            .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                            .frame(maxWidth: 40)
                            .background(Color(.systemGray3))
                            .cornerRadius(8)
                        Text(port.title ?? "")
                            .lineLimit(1)
                            .frame(maxWidth: 100, alignment: .leading)
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: portSpacing) {
                ForEach(node.outputs) { port in
                    HStack(alignment: .center, spacing: 8) {
                        if let data = graph.data(for: port.address) {
                            dataText(data.text, alignment: .trailing)
                        }
                        portCircle
                            .port(.output(node.id, index: port.id))
                    }
                }
            }
        }
        .padding(8)
    }

    func outputNode(node: Node) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: portSpacing) {
                ForEach(node.inputs) { port in
                    HStack(alignment: .center, spacing: 8) {
                        portCircle
                            .port(.input(node.id, index: port.id))
                        if let data = graph.data(for: port.address) {
                            dataText(data.text, alignment: .leading)
                        }
                        Text(port.title ?? "")
                            .lineLimit(1)
                            .frame(maxWidth: 100, alignment: .leading)
                    }
                }
            }
            Spacer()
        }
        .padding(8)
    }

    var body: some View {
        CanvasView(graph, nodeView: { node in
            NodeView(node) { inputs, outputs in
                VStack(spacing: 0) {
                    Text(node.title ?? "")
                        .bold()
                        .padding(8)
                    Divider()
                    if node.type == .input {
                        inputNode(node: node)
                    } else if node.type == .output {
                        outputNode(node: node)
                    } else {
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: portSpacing) {
                                ForEach(inputs) { port in
                                    HStack(alignment: .center, spacing: 8) {
                                        portCircle
                                            .port(port.address)
                                        Text(port.title ?? "")
                                        if let data = graph.data(for: port.address) {
                                            dataText(data.text, alignment: .leading)
                                        }
                                    }
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: portSpacing) {
                                ForEach(outputs) { port in
                                    HStack(alignment: .center, spacing: 8) {
                                        Text(port.title ?? "")
                                        if let data = graph.data(for: port.address) {
                                            dataText(data.text, alignment: .trailing)
                                        }
                                        portCircle
                                            .port(port.address)
                                    }
                                }
                            }
                        }
                        .padding(8)
                    }

                }
                .frame(width: 180)
                .background(Color(.systemGray4))
                .cornerRadius(8)
                .clipped()
                .shadow(radius: 8)
            }
        }, edgeView: { edge in
            if let start = graph.position(with: edge.source),
               let end = graph.position(with: edge.target) {
                EdgeShape(start: start, end: end)
                    .stroke(Color(.systemGray), lineWidth: 2)
            }
        }, connectionView: { connection in
            EdgeShape(start: connection.start, end: connection.end)
                .stroke(Color(.systemBlue), lineWidth: 2)
        })
        .background(Color(.secondarySystemGroupedBackground))
        .ignoresSafeArea()
    }
}

struct FlowCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        FlowCanvasView()
    }
}
