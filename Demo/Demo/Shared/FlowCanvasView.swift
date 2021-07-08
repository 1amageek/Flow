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
            .input(id: "R", title: "R", inputs: [.float(title: "R")], position: CGPoint(x: 200, y: 200)),
            .input(id: "G", title: "G", inputs: [.float(title: "B")], position: CGPoint(x: 200, y: 400)),
            .input(id: "B", title: "B", inputs: [.float(title: "B")], position: CGPoint(x: 200, y: 600)),
            .sum(type: .float(0), id: "SUM", title: "SUM", inputs: [.float(), .float(), .float()], position: CGPoint(x: 400, y: 400)),
            .output(id: "OUT", title: "OUT", outputs: [.float()], position: CGPoint(x: 650, y: 400)),

            .input(id: "DATAA", title: "DATA A", inputs: [.floatArray([1, 2, 3, 4], title: "R")], position: CGPoint(x: 200, y: 900)),
            .input(id: "DATAB", title: "DATA B", inputs: [.floatArray([1, 2, 3, 4], title: "R")], position: CGPoint(x: 200, y: 1100)),
            .product(type: .float(0), id: "PRODUCT", title: "PRODUCT", inputs: [.floatArray(), .floatArray()], position: CGPoint(x: 400, y: 1000)),

        ],
        edges: [
            Edge(source: .output("R", index: 0), target: .input("SUM", index: 0)),
            Edge(source: .output("G", index: 0), target: .input("SUM", index: 1)),
            Edge(source: .output("B", index: 0), target: .input("SUM", index: 2)),
            Edge(source: .output("SUM", index: 0), target: .input("OUT", index: 0)),

            Edge(source: .output("DATAA", index: 0), target: .input("PRODUCT", index: 0)),
            Edge(source: .output("DATAB", index: 0), target: .input("PRODUCT", index: 1)),
        ],
        shouldConnectNode: { _, edges, connection in
        return !edges.contains(where: { $0.target == connection.startAddress || $0.target == connection.endAddress })
    })

    let portSpacing: CGFloat = 24

    let portHeight: CGFloat = 24

    @ViewBuilder
    var portCircle: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(.systemGray2))
            .frame(width: 22, height: 22)
    }

    @ViewBuilder
    func dataText(_ text: String, alignment: Alignment) -> some View {
        Text(text)
            .lineLimit(1)
            .frame(maxWidth: 130, alignment: alignment)
    }

    func inputNode(node: Node) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: portSpacing) {
                ForEach(node.inputs) { port in
                    HStack(alignment: .center, spacing: 8) {
                        if case .bool(let value) = port.data {
//                            Toggle(isOn: $graph[node.id][.input(port.id)].boolValue) {
//
//                            }
                        } else {
                            TextField("0", text: $graph[node.id][.input(port.id)].text)
                                .multilineTextAlignment(.trailing)
                                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                                .frame(maxWidth: 100)
                                .background(Color(.systemGray3))
                                .cornerRadius(8)
                        }
                        Text(port.title ?? "")
                            .lineLimit(1)
                            .frame(maxWidth: 100, alignment: .leading)
                    }
                    .frame(height: portHeight)
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
                    .frame(height: portHeight)
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
                                    .frame(height: portHeight)
                                    .onTapGesture {
                                        print(graph.data(for: port.address))
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
                                    .frame(height: portHeight)
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
                .stroke(connection.isConnecting ? Color(.systemGreen) : Color(.systemBlue), lineWidth: 2)
        })
        .background(Color(.secondarySystemGroupedBackground))
        .ignoresSafeArea()
        .onTapGesture(count: 2) {
            graph.add(.sum(type: .float(), id: UUID().uuidString, title: "SUM", inputs: [.float(), .float()]))
        }
    }
}

struct FlowCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        FlowCanvasView()
    }
}
