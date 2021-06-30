import SwiftUI
import Foundation


protocol Input {

    associatedtype Body

    var body: Body { get }
}

struct TupleInput<T>: Input {

    var value: T

    init(_ value: T) {
        self.value = value
    }

    typealias Body = Never

    var body: Never { fatalError() }
}

struct ArrayInput<T>: Input {

    var value: [T]

    init(_ value: T...) {
        self.value = value
    }

    typealias Body = Never

    var body: Never { fatalError() }
}

struct EmptyInput: Input {

    typealias Body = Never

    var body: Never { fatalError() }
}

struct NumberInput<T: Numeric>: Input {

    typealias Body = T

    let value: T

    init(_ value: T) {
        self.value = value
    }

    var body: T { value }
}

@resultBuilder
struct InputBuilder {

//    static func buildBlock() -> EmptyInput {
//        return EmptyInput()
//    }
//
//    static func buildBlock<Content>(_ content: Content) -> Content where Content: Input {
//        return content
//    }
}

extension InputBuilder {

    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> ArrayInput<NumberInput<Int>> where C0: Input, C1: Input, C0.Body == Int, C1.Body == Int {
        return ArrayInput(NumberInput(c0.body), NumberInput(c1.body))
    }

    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> ArrayInput<NumberInput<CGFloat>> where C0: Input, C1: Input, C0.Body == CGFloat, C1.Body == CGFloat {
        return ArrayInput(NumberInput(c0.body), NumberInput(c1.body))
    }
}


extension InputBuilder {

    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleInput<(C0, C1)> where C0: Input, C1: Input {
        return TupleInput((c0, c1))
    }

    static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleInput<(C0, C1, C2)> where C0: Input, C1: Input, C2: Input {
        return TupleInput((c0, c1, c2))
    }
}

protocol Node {

//    associatedtype InputPort: Input

}

func arrayFromTuple<T, U>(tuple: T) -> [U] {
    return Mirror(reflecting: tuple).children.map { $0.value as! U }
}

struct Sum<T: Numeric>: Node {

    let input: () -> ArrayInput<NumberInput<T>>

    init(@InputBuilder input: @escaping () -> ArrayInput<NumberInput<T>>) {
        self.input = input
    }

    func callAsFunction() -> Void {
        let input: ArrayInput<NumberInput<T>> = input()
        let total = input.value.map { $0.body }.reduce(.zero, +)
        print(total)
    }
}

struct SSSM<T: Numeric>: Node {

    var inputs: [T]

    var outputs: [T] {
        return [inputs[0] + inputs[1], inputs[0] + inputs[1]]
    }

    func callAsFunction(_ port: Int) -> T {
        return self.outputs[port]
    }
}

//struct Sum<T, U> {
//
//    typealias Input = T
//    typealias Output = U
//
//}
//
//extension Sum where Input == Output {
//
//    func callAsFunction(_ input: Input) -> Output {
//        return input
//    }
//}

//
let sum = Sum<Int> {
    NumberInput(1)
    NumberInput(23)
}

sum()

