import XCTest
@testable import Flow

final class CodableTests: XCTestCase {

    func testNodeType() throws {
        do {
            let nodeType = NodeType.input("A")
            let data = try JSONEncoder().encode(nodeType)
            let result = try! JSONDecoder().decode(NodeType.self, from: data)
            XCTAssertEqual(result, NodeType.input("A"))
        }
        do {
            let nodeType = NodeType.output("A")
            let data = try JSONEncoder().encode(nodeType)
            let result = try! JSONDecoder().decode(NodeType.self, from: data)
            XCTAssertEqual(result, NodeType.output("A"))
        }
        do {
            let nodeType = NodeType.io("A")
            let data = try JSONEncoder().encode(nodeType)
            let result = try! JSONDecoder().decode(NodeType.self, from: data)
            XCTAssertEqual(result, NodeType.io("A"))
        }
    }

    func testNodeBypass() throws {
        let node = Node(type: .input(Node.Function.bypass), id: "ID", name: "NAME", inputs: [], outputs: [])
        let data = try JSONEncoder().encode(node)
        let result = try! JSONDecoder().decode(Node.self, from: data)
        XCTAssertEqual(result.type, .input(Node.Function.bypass))
        XCTAssertEqual(result.id, "ID")
        XCTAssertEqual(result.name, "NAME")
    }

    func testNodeSum() throws {
        let node = Node(type: .input(Node.Function.sum), id: "ID", name: "NAME", inputs: [], outputs: [])
        let data = try JSONEncoder().encode(node)
        let result = try! JSONDecoder().decode(Node.self, from: data)
        XCTAssertEqual(result.type, .input(Node.Function.sum))
        XCTAssertEqual(result.id, "ID")
        XCTAssertEqual(result.name, "NAME")
    }

    func testNodeProduct() throws {
        let node = Node(type: .input(Node.Function.product), id: "ID", name: "NAME", inputs: [], outputs: [])
        let data = try JSONEncoder().encode(node)
        let result = try! JSONDecoder().decode(Node.self, from: data)
        XCTAssertEqual(result.type, .input(Node.Function.product))
        XCTAssertEqual(result.id, "ID")
        XCTAssertEqual(result.name, "NAME")
    }

    func testEdge() throws {
        let edge = Edge(id: "ID", source: .input("A", index: 0), target: .input("B", index: 0))
        let data = try JSONEncoder().encode(edge)
        let result = try! JSONDecoder().decode(Edge.self, from: data)
        XCTAssertEqual(result.id, "ID")
        XCTAssertEqual(result.source, .input("A", index: 0))
        XCTAssertEqual(result.target, .input("B", index: 0))
    }
}
