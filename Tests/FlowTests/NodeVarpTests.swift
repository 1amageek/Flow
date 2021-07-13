import XCTest
@testable import Flow

final class NodeVarpTests: XCTestCase {

    func testNodeVarpBool() throws {
        let n0 = Varp()
        do {
            let output = n0([.bool(false), .bool(false)], [.bool()])
            XCTAssertNil(output.first!.boolValue)
        }
    }

    func testNodeVarpInt() throws {
        let n0 = Varp()
        do {
            let output = n0([.int(0), .int(0)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 0)
        }
        do {
            let output = n0([.int(1), .int(1)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 0)
        }
        do {
            let output = n0([.int(1), .int(1), .int(1)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 0)
        }
        do {
            let output = n0([.int(23), .int(26), .int(26)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 2)
        }
        do {
            let output = n0([.int(10), .int(10), .int(-2)], [.int()])
            XCTAssertEqual(output.first!.intValue!, 32)
        }
    }

    func testNodeVarpFloat() throws {
        let n0 = Varp()
        do {
            let output = n0([.float(0), .float(0)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 0)
        }
        do {
            let output = n0([.float(1), .float(1)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 0)
        }
        do {
            let output = n0([.float(1), .float(1), .float(1)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 0)
        }
        do {
            let output = n0([.int(23), .int(26), .int(26)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 2)
        }
        do {
            let output = n0([.int(10), .int(10), .int(-2)], [.float()])
            XCTAssertEqual(output.first!.floatValue!, 32)
        }
    }

    func testNodeVarpString() throws {
        let n0 = Varp()
        do {
            let output = n0([.string("a"), .string("b")], [.string()])
            XCTAssertNil(output.first!.stringValue)
        }
        do {
            let output = n0([.string("a"), .string("b"), .string("c")], [.string()])
            XCTAssertNil(output.first!.stringValue)
        }
    }

    func testNodeVarpBoolArray() throws {
        let n0 = Varp()
        let output = n0([.boolArray([false]), .boolArray([false])], [.boolArray()])
        XCTAssertNil(output.first!.boolArrayValue)
    }

    func testNodeVarpIntArray() throws {
        let n0 = Varp()
        do {
            let output = n0([.intArray([0]), .intArray([0])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [0])
        }
        do {
            let output = n0([.intArray([1]), .intArray([1])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [0])
        }
        do {
            let output = n0([.intArray([23]), .intArray([26]), .intArray([26])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [2])
        }
        do {
            let output = n0([.intArray([10]), .intArray([10]), .intArray([-2])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [32])
        }
        do {
            let output = n0([.intArray([23, 23]), .intArray([26, 26]), .intArray([26, 26])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [2, 2])
        }
        do {
            let output = n0([.intArray([10, 10]), .intArray([10, 10]), .intArray([-2, -2])], [.intArray()])
            XCTAssertEqual(output.first!.intArrayValue!, [32, 32])
        }
    }

    func testNodeVarpFloatArray() throws {
        let n0 = Varp()
        do {
            let output = n0([.floatArray([0]), .floatArray([0])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [0])
        }
        do {
            let output = n0([.floatArray([1]), .floatArray([1])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [0])
        }
        do {
            let output = n0([.floatArray([23]), .floatArray([26]), .floatArray([26])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [2])
        }
        do {
            let output = n0([.floatArray([10]), .floatArray([10]), .floatArray([-2])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [32])
        }
        do {
            let output = n0([.floatArray([23, 23]), .floatArray([26, 26]), .floatArray([26, 26])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [2, 2])
        }
        do {
            let output = n0([.floatArray([10, 10]), .floatArray([10, 10]), .floatArray([-2, -2])], [.floatArray()])
            XCTAssertEqual(output.first!.floatArrayValue!, [32, 32])
        }
    }

    func testNodeVarpStringArray() throws {
        let n0 = Varp()
        do {
            let output = n0([.stringArray(["a"]), .stringArray(["b"])], [.stringArray()])
            XCTAssertNil(output.first!.stringArrayValue)
        }
        do {
            let output = n0([.stringArray(["a"]), .stringArray(["b"]), .stringArray(["c"])], [.stringArray()])
            XCTAssertNil(output.first!.stringArrayValue)
        }
    }
}
