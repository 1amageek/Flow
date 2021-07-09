import XCTest
@testable import Flow

final class NodeAverageTests: XCTestCase {

    func testNodeAverageBool() throws {
        let n0 = Node.average(portData: .bool(), id: "", name: "")
        do {
            let output = n0([.bool(false), .bool(false)])
            XCTAssertNil(output.first!.boolValue)
        }
    }

    func testNodeAverageInt() throws {
        let n0 = Node.average(portData: .int(), id: "", name: "")
        do {
            let output = n0([.int(0), .int(0)])
            XCTAssertEqual(output.first!.intValue!, 0)
        }
        do {
            let output = n0([.int(1), .int(1)])
            XCTAssertEqual(output.first!.intValue!, 1)
        }
        do {
            let output = n0([.int(1), .int(1), .int(1)])
            XCTAssertEqual(output.first!.intValue!, 1)
        }
        do {
            let output = n0([.int(2), .int(2), .int(2)])
            XCTAssertEqual(output.first!.intValue!, 2)
        }
        do {
            let output = n0([.int(10), .int(11), .int(12)])
            XCTAssertEqual(output.first!.intValue!, 11)
        }
        do {
            let output = n0([.int(10), .int(10), .int(-2)])
            XCTAssertEqual(output.first!.intValue!, 6)
        }
    }

    func testNodeAverageFloat() throws {
        let n0 = Node.average(portData: .float(), id: "", name: "")
        do {
            let output = n0([.float(0), .float(0)])
            XCTAssertEqual(output.first!.floatValue!, 0)
        }
        do {
            let output = n0([.float(1), .float(1)])
            XCTAssertEqual(output.first!.floatValue!, 1)
        }
        do {
            let output = n0([.float(1), .float(1), .float(1)])
            XCTAssertEqual(output.first!.floatValue!, 1)
        }
        do {
            let output = n0([.float(2), .float(2), .float(2)])
            XCTAssertEqual(output.first!.floatValue!, 2)
        }
        do {
            let output = n0([.float(10), .float(11), .float(12)])
            XCTAssertEqual(output.first!.floatValue!, 11)
        }
        do {
            let output = n0([.float(10), .float(10), .float(-2)])
            XCTAssertEqual(output.first!.floatValue!, 6)
        }
    }

    func testNodeAverageString() throws {
        let n0 = Node.average(portData: .string(), id: "", name: "")
        do {
            let output = n0([.string("a"), .string("b")])
            XCTAssertNil(output.first!.stringValue)
        }
        do {
            let output = n0([.string("a"), .string("b"), .string("c")])
            XCTAssertNil(output.first!.stringValue)
        }
    }

    func testNodeAverageBoolArray() throws {
        let n0 = Node.average(portData: .boolArray(), id: "", name: "")
        let output = n0([.bool(false), .bool(false)])
        XCTAssertNil(output.first!.boolValue)
    }

    func testNodeAverageIntArray() throws {
        let n0 = Node.average(portData: .intArray(), id: "", name: "")
        do {
            let output = n0([.intArray([0]), .intArray([0])])
            XCTAssertEqual(output.first!.intArrayValue!, [0])
        }
        do {
            let output = n0([.intArray([1]), .intArray([1])])
            XCTAssertEqual(output.first!.intArrayValue!, [1])
        }
        do {
            let output = n0([.intArray([2]), .intArray([2])])
            XCTAssertEqual(output.first!.intArrayValue!, [2])
        }
        do {
            let output = n0([.intArray([2, 3]), .intArray([2, 3])])
            XCTAssertEqual(output.first!.intArrayValue!, [2, 3])
        }
        do {
            let output = n0([.intArray([2, 3]), .intArray([2, 3]), .intArray([2, 3])])
            XCTAssertEqual(output.first!.intArrayValue!, [2, 3])
        }
    }

    func testNodeAverageFloatArray() throws {
        let n0 = Node.average(portData: .floatArray(), id: "", name: "")
        do {
            let output = n0([.floatArray([0]), .floatArray([0])])
            XCTAssertEqual(output.first!.floatArrayValue!, [0])
        }
        do {
            let output = n0([.floatArray([1]), .floatArray([1])])
            XCTAssertEqual(output.first!.floatArrayValue!, [1])
        }
        do {
            let output = n0([.floatArray([2]), .floatArray([2])])
            XCTAssertEqual(output.first!.floatArrayValue!, [2])
        }
        do {
            let output = n0([.floatArray([2, 3]), .floatArray([2, 3])])
            XCTAssertEqual(output.first!.floatArrayValue!, [2, 3])
        }
        do {
            let output = n0([.floatArray([2, 3]), .floatArray([2, 3]), .floatArray([2, 3])])
            XCTAssertEqual(output.first!.floatArrayValue!, [2, 3])
        }
    }

    func testNodeAverageStringArray() throws {
        let n0 = Node.average(portData: .stringArray(), id: "", name: "")
        do {
            let output = n0([.stringArray(["a"]), .stringArray(["b"])])
            XCTAssertNil(output.first!.stringArrayValue)
        }
        do {
            let output = n0([.string("a"), .string("b"), .string("c")])
            XCTAssertNil(output.first!.stringArrayValue)
        }
    }
}
