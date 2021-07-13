import XCTest
@testable import Flow

final class CallableOverrideTests: XCTestCase {

    struct AFunction: Callable {
        var id: ID { "FUNC" }

        func callAsFunction(_ input: Input, _ output: Output) -> [PortData] {
            return input
        }

        func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData {
            fatalError()
        }
    }

    func testOverride() throws {

        let aFunc = AFunction()

        let ouput = aFunc([.float(0), .float(1)], [.float(0), .float(1)])

        XCTAssertEqual(ouput[0].floatValue, 0)
        XCTAssertEqual(ouput[1].floatValue, 1)
    }
}
