import XCTest
@testable import Flow

final class NodeVarpTests: XCTestCase {

    func testNodeVarpBool() throws {
        let n0 = Node.varp(type: .bool(), id: "", title: "")
        do {
            let output = n0([.bool(false), .bool(false)])
            XCTAssertNil(output.first!.boolValue)
        }
    }

    func testNodeVarpInt() throws {
        let n0 = Node.varp(type: .int(), id: "", title: "")
        do {
            let output = n0([.int(0), .int(0)])
            XCTAssertEqual(output.first!.intValue!, 0)
        }
        do {
            let output = n0([.int(1), .int(1)])
            XCTAssertEqual(output.first!.intValue!, 0)
        }
        do {
            let output = n0([.int(1), .int(1), .int(1)])
            XCTAssertEqual(output.first!.intValue!, 0)
        }
        do {
            let output = n0([.int(23), .int(26), .int(26)])
            XCTAssertEqual(output.first!.intValue!, 2)
        }
        do {
            let output = n0([.int(10), .int(10), .int(-2)])
            XCTAssertEqual(output.first!.intValue!, 32)
        }
    }

    func testNodeVarpFloat() throws {
        let n0 = Node.varp(type: .float(), id: "", title: "")
        do {
            let output = n0([.float(0), .float(0)])
            XCTAssertEqual(output.first!.floatValue!, 0)
        }
        do {
            let output = n0([.float(1), .float(1)])
            XCTAssertEqual(output.first!.floatValue!, 0)
        }
        do {
            let output = n0([.float(1), .float(1), .float(1)])
            XCTAssertEqual(output.first!.floatValue!, 0)
        }
        do {
            let output = n0([.int(23), .int(26), .int(26)])
            XCTAssertEqual(output.first!.floatValue!, 2)
        }
        do {
            let output = n0([.int(10), .int(10), .int(-2)])
            XCTAssertEqual(output.first!.floatValue!, 32)
        }
    }

    func testNodeVarpString() throws {
        let n0 = Node.varp(type: .string(), id: "", title: "")
        do {
            let output = n0([.string("a"), .string("b")])
            XCTAssertNil(output.first!.stringValue)
        }
        do {
            let output = n0([.string("a"), .string("b"), .string("c")])
            XCTAssertNil(output.first!.stringValue)
        }
    }

    func testNodeVarpBoolArray() throws {
        let n0 = Node.varp(type: .boolArray(), id: "", title: "")
        let output = n0([.boolArray([false]), .boolArray([false])])
        XCTAssertNil(output.first!.boolArrayValue)
    }

    func testNodeVarpIntArray() throws {
        let n0 = Node.varp(type: .intArray(), id: "", title: "")
        do {
            let output = n0([.intArray([0]), .intArray([0])])
            XCTAssertEqual(output.first!.intArrayValue!, [0])
        }
        do {
            let output = n0([.intArray([1]), .intArray([1])])
            XCTAssertEqual(output.first!.intArrayValue!, [0])
        }
        do {
            let output = n0([.intArray([23]), .intArray([26]), .intArray([26])])
            XCTAssertEqual(output.first!.intArrayValue!, [2])
        }
        do {
            let output = n0([.intArray([10]), .intArray([10]), .intArray([-2])])
            XCTAssertEqual(output.first!.intArrayValue!, [32])
        }
        do {
            let output = n0([.intArray([23, 23]), .intArray([26, 26]), .intArray([26, 26])])
            XCTAssertEqual(output.first!.intArrayValue!, [2, 2])
        }
        do {
            let output = n0([.intArray([10, 10]), .intArray([10, 10]), .intArray([-2, -2])])
            XCTAssertEqual(output.first!.intArrayValue!, [32, 32])
        }
    }

    func testNodeVarpFloatArray() throws {
        let n0 = Node.varp(type: .floatArray(), id: "", title: "")
        do {
            let output = n0([.floatArray([0]), .floatArray([0])])
            XCTAssertEqual(output.first!.floatArrayValue!, [0])
        }
        do {
            let output = n0([.floatArray([1]), .floatArray([1])])
            XCTAssertEqual(output.first!.floatArrayValue!, [0])
        }
        do {
            let output = n0([.floatArray([23]), .floatArray([26]), .floatArray([26])])
            XCTAssertEqual(output.first!.floatArrayValue!, [2])
        }
        do {
            let output = n0([.floatArray([10]), .floatArray([10]), .floatArray([-2])])
            XCTAssertEqual(output.first!.floatArrayValue!, [32])
        }
        do {
            let output = n0([.floatArray([23, 23]), .floatArray([26, 26]), .floatArray([26, 26])])
            XCTAssertEqual(output.first!.floatArrayValue!, [2, 2])
        }
        do {
            let output = n0([.floatArray([10, 10]), .floatArray([10, 10]), .floatArray([-2, -2])])
            XCTAssertEqual(output.first!.floatArrayValue!, [32, 32])
        }
    }

    func testNodeVarpStringArray() throws {
        let n0 = Node.varp(type: .stringArray(), id: "", title: "")
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
