import XCTest
@testable import Flow

final class NodeAverageTests: XCTestCase {

    func testNodeAverageBool() throws {
        let n0 = Average()
        do {
            let output = n0([.bool(false), .bool(false)], [.bool()])
            XCTAssertNil(output.first!.boolValue)
        }
    }

    func testNodeAverageInt() throws {
        let n0 = Average()
        do {
            let output = n0([.int(0), .int(0)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 0)
        }
        do {
            let output = n0([.int(1), .int(1)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 1)
        }
        do {
            let output = n0([.int(1), .int(1), .int(1)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 1)
        }
        do {
            let output = n0([.int(2), .int(2), .int(2)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 2)
        }
        do {
            let output = n0([.int(10), .int(11), .int(12)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 11)
        }
        do {
            let output = n0([.int(10), .int(10), .int(-2)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 6)
        }
    }

    func testNodeAverageFloat() throws {
        let n0 = Average()
        do {
            let output = n0([.float(0), .float(0)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 0)
        }
        do {
            let output = n0([.float(1), .float(1)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 1)
        }
        do {
            let output = n0([.float(1), .float(1), .float(1)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 1)
        }
        do {
            let output = n0([.float(2), .float(2), .float(2)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 2)
        }
        do {
            let output = n0([.float(10), .float(11), .float(12)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 11)
        }
        do {
            let output = n0([.float(10), .float(10), .float(-2)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 6)
        }
    }

    func testNodeAverageString() throws {
        let n0 = Average()
        do {
            let output = n0([.string("a"), .string("b")], [.string()])
            XCTAssertNil(output.first!.stringValue)
        }
        do {
            let output = n0([.string("a"), .string("b"), .string("c")], [.string()])
            XCTAssertNil(output.first!.stringValue)
        }
    }

    func testNodeAverageBoolArray() throws {
        let n0 = Average()
        let output = n0([.boolArray([false]), .boolArray([false])], [.boolArray()])
        XCTAssertNil(output.first!.boolValue)
    }

    func testNodeAverageIntArray() throws {
        let n0 = Average()
        do {
            let output = n0([.intArray([0]), .intArray([0])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [0])
        }
        do {
            let output = n0([.intArray([1]), .intArray([1])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [1])
        }
        do {
            let output = n0([.intArray([2]), .intArray([2])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [2])
        }
        do {
            let output = n0([.intArray([2, 3]), .intArray([2, 3])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [2, 3])
        }
        do {
            let output = n0([.intArray([2, 3]), .intArray([2, 3]), .intArray([2, 3])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [2, 3])
        }
    }

    func testNodeAverageFloatArray() throws {
        let n0 = Average()
        do {
            let output = n0([.floatArray([0]), .floatArray([0])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [0])
        }
        do {
            let output = n0([.floatArray([1]), .floatArray([1])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [1])
        }
        do {
            let output = n0([.floatArray([2]), .floatArray([2])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [2])
        }
        do {
            let output = n0([.floatArray([2, 3]), .floatArray([2, 3])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [2, 3])
        }
        do {
            let output = n0([.floatArray([2, 3]), .floatArray([2, 3]), .floatArray([2, 3])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [2, 3])
        }
    }

    func testNodeAverageStringArray() throws {
        let n0 = Average()
        do {
            let output = n0([.stringArray(["a"]), .stringArray(["b"])], [.stringArray()])
            XCTAssertNil(output.first!.stringArrayValue)
        }
        do {
            let output = n0([.string("a"), .string("b"), .string("c")], [.stringArray()])
            XCTAssertNil(output.first!.stringArrayValue)
        }
    }
}
