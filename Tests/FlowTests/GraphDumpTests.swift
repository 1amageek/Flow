import XCTest
@testable import Flow

final class GraphDumpTests: XCTestCase {

    func testDump() throws {
        let graph: Graph = Graph(
            nodes: [
                .input(id: "R", name: "R", inputs: [.float(name: "R")], position: CGPoint(x: 200, y: 200)),
                .input(id: "G", name: "G", inputs: [.float(name: "B")], position: CGPoint(x: 200, y: 400)),
                .input(id: "B", name: "B", inputs: [.float(name: "B")], position: CGPoint(x: 200, y: 600)),
                .sum(portData: .float(0), id: "SUM", name: "SUM", inputs: [.float(), .float(), .float()], position: CGPoint(x: 400, y: 400)),
                .output(id: "OUT", name: "OUT", outputs: [.float()], position: CGPoint(x: 650, y: 400)),

                .input(id: "DATAA", name: "DATA A", inputs: [.floatArray([1, 2, 3, 4], name: "R")], position: CGPoint(x: 200, y: 900)),
                .input(id: "DATAB", name: "DATA B", inputs: [.floatArray([1, 2, 3, 4], name: "R")], position: CGPoint(x: 200, y: 1100)),
                .product(portData: .floatArray(), id: "PRODUCT", name: "PRODUCT", inputs: [.floatArray(), .floatArray()], position: CGPoint(x: 400, y: 1000)),

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

        let data = try! graph.dump()
        let snapshot = try! JSONDecoder().decode(Graph.Snapshot.self, from: data)

        XCTAssertEqual(snapshot.nodes[0].id, "R")
        XCTAssertEqual(snapshot.nodes[1].id, "G")
        XCTAssertEqual(snapshot.nodes[2].id, "B")
        XCTAssertEqual(snapshot.nodes[0].name, "R")
        XCTAssertEqual(snapshot.nodes[1].name, "G")
        XCTAssertEqual(snapshot.nodes[2].name, "B")
        XCTAssertEqual(snapshot.nodes[0].inputs[0].nodeID, "R")
        XCTAssertEqual(snapshot.nodes[1].inputs[0].nodeID, "G")
        XCTAssertEqual(snapshot.nodes[2].inputs[0].nodeID, "B")
        XCTAssertEqual(snapshot.nodes[0].inputs[0].type, .input)
        XCTAssertEqual(snapshot.nodes[1].inputs[0].type, .input)
        XCTAssertEqual(snapshot.nodes[2].inputs[0].type, .input)

        XCTAssertEqual(snapshot.edges[0].source.id, "R")
        XCTAssertEqual(snapshot.edges[1].source.id, "G")
        XCTAssertEqual(snapshot.edges[2].source.id, "B")
        XCTAssertEqual(snapshot.edges[0].target.id, "SUM")
        XCTAssertEqual(snapshot.edges[1].target.id, "SUM")
        XCTAssertEqual(snapshot.edges[2].target.id, "SUM")
    }
}
