# Flow

Flow is a library for expressing Graph in Swift UI.


## Usage

__Declare Graph__

```swift
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
```

__Representing Node and Edge__

```swift

                CanvasView(graph, nodeView: { node in
            NodeView(node) { inputs, outputs in
                VStack(spacing: 0) {
                    Text(node.title ?? "")
                        .bold()
                        .padding(8)
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

```
