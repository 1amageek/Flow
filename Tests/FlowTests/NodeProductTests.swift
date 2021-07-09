import XCTest
@testable import Flow

final class NodeProductTests: XCTestCase {

    func testNodeProductBool() throws {
        let n0 = Node.product(portData: .bool(), id: "", name: "")
        do {
            let output = n0([.bool(false), .bool(false)])
            XCTAssertFalse(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(true), .bool(false)])
            XCTAssertFalse(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(false), .bool(true)])
            XCTAssertFalse(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(true), .bool(true)])
            XCTAssertTrue(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(false), .bool(false), .bool(false)])
            XCTAssertFalse(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(true), .bool(false), .bool(false)])
            XCTAssertFalse(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(false), .bool(true), .bool(false)])
            XCTAssertFalse(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(true), .bool(true), .bool(false)])
            XCTAssertFalse(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(true), .bool(true), .bool(true)])
            XCTAssertTrue(output.first!.boolValue!)
        }
    }

    func testNodeProductInt() throws {
        let n0 = Node.product(portData: .int(), id: "", name: "")
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
            XCTAssertEqual(output.first!.intValue!, 8)
        }
        do {
            let output = n0([.int(2), .int(2), .int(-2)])
            XCTAssertEqual(output.first!.intValue!, -8)
        }
        do {
            let output = n0([.int(2), .int(-2), .int(-2)])
            XCTAssertEqual(output.first!.intValue!, 8)
        }
    }

    func testNodeProductFloat() throws {
        let n0 = Node.product(portData: .float(), id: "", name: "")
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
            XCTAssertEqual(output.first!.floatValue!, 8)
        }
        do {
            let output = n0([.float(2), .float(2), .float(-2)])
            XCTAssertEqual(output.first!.floatValue!, -8)
        }
        do {
            let output = n0([.float(2), .float(-2), .float(-2)])
            XCTAssertEqual(output.first!.floatValue!, 8)
        }
    }

    func testNodeProductString() throws {
        let n0 = Node.product(portData: .string(), id: "", name: "")
        do {
            let output = n0([.string("a"), .string("b")])
            XCTAssertNil(output.first!.stringValue)
        }
        do {
            let output = n0([.string("a"), .string("b"), .string("c")])
            XCTAssertNil(output.first!.stringValue)
        }
    }

    func testNodeProductBoolArray() throws {
        let n0 = Node.product(portData: .boolArray(), id: "", name: "")
        do {
            let output = n0([.boolArray([false]), .boolArray([false])])
            XCTAssertEqual(output.first!.boolArrayValue!, [false])
        }
        do {
            let output = n0([.boolArray([true]), .boolArray([false])])
            XCTAssertEqual(output.first!.boolArrayValue!, [false])
        }
        do {
            let output = n0([.boolArray([true]), .boolArray([true])])
            XCTAssertEqual(output.first!.boolArrayValue!, [true])
        }
        do {
            let output = n0([.boolArray([false, false]), .boolArray([false, false])])
            XCTAssertEqual(output.first!.boolArrayValue!, [false, false])
        }
        do {
            let output = n0([.boolArray([true, false]), .boolArray([false, false])])
            XCTAssertEqual(output.first!.boolArrayValue!, [false, false])
        }
        do {
            let output = n0([.boolArray([true, false]), .boolArray([true, false])])
            XCTAssertEqual(output.first!.boolArrayValue!, [true, false])
        }
        do {
            let output = n0([.boolArray([false, true]), .boolArray([false, true])])
            XCTAssertEqual(output.first!.boolArrayValue!, [false, true])
        }
        do {
            let output = n0([.boolArray([true, true]), .boolArray([false, true])])
            XCTAssertEqual(output.first!.boolArrayValue!, [false, true])
        }
        do {
            let output = n0([.boolArray([true, true]), .boolArray([true, true])])
            XCTAssertEqual(output.first!.boolArrayValue!, [true, true])
        }
    }

    func testNodeProductIntArray() throws {
        let n0 = Node.product(portData: .intArray(), id: "", name: "")
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
            XCTAssertEqual(output.first!.intArrayValue!, [4])
        }
        do {
            let output = n0([.intArray([2, 3]), .intArray([2, 3])])
            XCTAssertEqual(output.first!.intArrayValue!, [4, 9])
        }
        do {
            let output = n0([.intArray([2, 3]), .intArray([2, 3]), .intArray([2, 3])])
            XCTAssertEqual(output.first!.intArrayValue!, [8, 27])
        }
    }

    func testNodeProductFloatArray() throws {
        let n0 = Node.product(portData: .floatArray(), id: "", name: "")
        do {
            let output = n0([.floatArray([0]), .floatArray([0])])
            XCTAssertEqual(output.first!.intArrayValue!, [0])
        }
        do {
            let output = n0([.floatArray([1]), .floatArray([1])])
            XCTAssertEqual(output.first!.intArrayValue!, [1])
        }
        do {
            let output = n0([.floatArray([2]), .floatArray([2])])
            XCTAssertEqual(output.first!.intArrayValue!, [4])
        }
        do {
            let output = n0([.floatArray([2, 3]), .floatArray([2, 3])])
            XCTAssertEqual(output.first!.intArrayValue!, [4, 9])
        }
        do {
            let output = n0([.floatArray([2, 3]), .floatArray([2, 3]), .floatArray([2, 3])])
            XCTAssertEqual(output.first!.intArrayValue!, [8, 27])
        }
    }

    func testNodeProductStringArray() throws {
        let n0 = Node.product(portData: .stringArray(), id: "", name: "")
        do {
            let output = n0([.stringArray(["a"]), .stringArray(["b"])])
            XCTAssertNil(output.first!.stringArrayValue)
        }
    }
}
