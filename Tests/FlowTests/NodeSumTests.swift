import XCTest
@testable import Flow

final class NodeSumTests: XCTestCase {
    
    func testNodeSumBool() throws {
        let n0 = Sum()
        do {
            let output = n0([.bool(false), .bool(false)], [.bool()])
            XCTAssertFalse(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(true), .bool(false)], [.bool()])
            XCTAssertTrue(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(false), .bool(true)], [.bool()])
            XCTAssertTrue(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(true), .bool(true)], [.bool()])
            XCTAssertTrue(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(false), .bool(false), .bool(false)], [.bool()])
            XCTAssertFalse(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(true), .bool(false), .bool(false)], [.bool()])
            XCTAssertTrue(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(false), .bool(true), .bool(false)], [.bool()])
            XCTAssertTrue(output.first!.boolValue!)
        }
        do {
            let output = n0([.bool(true), .bool(true), .bool(false)], [.bool()])
            XCTAssertTrue(output.first!.boolValue!)
        }
    }

    func testNodeSumInt() throws {
        let n0 = Sum()
        do {
            let output = n0([.int(0), .int(0)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 0)
        }
        do {
            let output = n0([.int(1), .int(1)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 2)
        }
        do {
            let output = n0([.int(1), .int(1), .int(1)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 3)
        }
        do {
            let output = n0([.int(1), .int(1), .int(-1)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 1)
        }
        do {
            let output = n0([.int(1), .int(-1), .int(-1)], [.int()])
            XCTAssertEqual(output.first!.intValue!, -1)
        }
    }

    func testNodeSumFloat() throws {
        let n0 = Sum()
        do {
            let output = n0([.float(0), .float(0)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 0)
        }
        do {
            let output = n0([.float(1), .float(1)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 2)
        }
        do {
            let output = n0([.float(1), .float(1), .float(1)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 3)
        }
        do {
            let output = n0([.float(1), .float(1), .float(-1)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 1)
        }
        do {
            let output = n0([.float(1), .float(-1), .float(-1)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, -1)
        }
    }

    func testNodeSumString() throws {
        let n0 = Sum()
        do {
            let output = n0([.string("a"), .string("b")], [.string()])
            XCTAssertEqual(output.first!.stringValue!, "ab")
        }
        do {
            let output = n0([.string("a"), .string("b"), .string("c")], [.string()])
            XCTAssertEqual(output.first!.stringValue!, "abc")
        }
    }

    func testNodeSumBoolArray() throws {
        let n0 = Sum()
        do {
            let output = n0([.boolArray([false]), .boolArray([false])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [false])
        }
        do {
            let output = n0([.boolArray([false]), .boolArray([true])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [true])
        }
        do {
            let output = n0([.boolArray([true]), .boolArray([false])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [true])
        }
        do {
            let output = n0([.boolArray([true]), .boolArray([true])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [true])
        }
        do {
            let output = n0([.boolArray([false, false]), .boolArray([false, false])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [false, false])
        }
        do {
            let output = n0([.boolArray([false, false]), .boolArray([true, false])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [true, false])
        }
        do {
            let output = n0([.boolArray([true, false]), .boolArray([false, false])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [true, false])
        }
        do {
            let output = n0([.boolArray([true, false]), .boolArray([true, false])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [true, false])
        }
        do {
            let output = n0([.boolArray([false, true]), .boolArray([false, true])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [false, true])
        }
        do {
            let output = n0([.boolArray([false, true]), .boolArray([true, true])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [true, true])
        }
        do {
            let output = n0([.boolArray([true, true]), .boolArray([false, true])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [true, true])
        }
        do {
            let output = n0([.boolArray([true, true]), .boolArray([true, true]), .boolArray([true, true])], [.boolArray()])
            XCTAssertEqual(output.first!.boolArrayValue!, [true, true])
        }

    }

    func testNodeSumIntArray() throws {
        let n0 = Sum()
        do {
            let output = n0([.intArray([0]), .intArray([0])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [0])
        }
        do {
            let output = n0([.intArray([0]), .intArray([1])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [1])
        }
        do {
            let output = n0([.intArray([0, 0]), .intArray([1, 1])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [1, 1])
        }
        do {
            let output = n0([.intArray([0, 0]), .intArray([1, 1]), .intArray([2, 2])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [3, 3])
        }
        do {
            let output = n0([.intArray([0, 0, 0]), .intArray([1, 1, 1])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [1, 1, 1])
        }
        do {
            let output = n0([.intArray([0, 0, 0]), .intArray([1, 1, 1]), .intArray([2, 2, 2])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [3, 3, 3])
        }
    }

    func testNodeSumFloatArray() throws {
        let n0 = Sum()
        do {
            let output = n0([.floatArray([0]), .floatArray([0])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [0])
        }
        do {
            let output = n0([.floatArray([0]), .floatArray([1])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [1])
        }
        do {
            let output = n0([.floatArray([0, 0]), .floatArray([1, 1])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [1, 1])
        }
        do {
            let output = n0([.floatArray([0, 0]), .floatArray([1, 1]), .floatArray([2, 2])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [3, 3])
        }
        do {
            let output = n0([.floatArray([0, 0, 0]), .floatArray([1, 1, 1])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [1, 1, 1])
        }
        do {
            let output = n0([.floatArray([0, 0, 0]), .floatArray([1, 1, 1]), .floatArray([2, 2, 2])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [3, 3, 3])
        }
    }

    func testNodeSumStringArray() throws {
        let n0 = Sum()
        do {
            let output = n0([.stringArray(["a"]), .stringArray(["b"])], [.stringArray()])
            XCTAssertEqual(output.first!.stringArrayValue!, ["ab"])
        }
        do {
            let output = n0([.stringArray(["a"]), .stringArray(["b"]), .stringArray(["c"])], [.stringArray()])
            XCTAssertEqual(output.first!.stringArrayValue!, ["abc"])
        }
        do {
            let output = n0([.stringArray(["a", "a"]), .stringArray(["b", "b"])], [.stringArray()])
            XCTAssertEqual(output.first!.stringArrayValue!, ["ab", "ab"])
        }
        do {
            let output = n0([.stringArray(["a", "a"]), .stringArray(["b", "b"]), .stringArray(["c", "c"])], [.stringArray()])
            XCTAssertEqual(output.first!.stringArrayValue!, ["abc", "abc"])
        }
    }
}
