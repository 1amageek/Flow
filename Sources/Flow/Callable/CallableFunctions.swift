//
//  CallableFunctions.swift
//  
//
//  Created by nori on 2021/07/13.
//

import Foundation
import CoreGraphics
import Accelerate

extension Node {

    public struct Function {

        public static var bypass: Callable.ID { "BYPASS" }

        public static var sum: Callable.ID { "SUM" }

        public static var product: Callable.ID { "PRODUCT" }

        public static var average: Callable.ID { "AVERAGE" }

        public static var varp: Callable.ID { "VARP" }

    }
}

final public class CallableFunctions: CallableFunctionsProtocol {

    public static let functions: [Callable] = [Bypass(), Sum(), Product(), Average(), Varp()]

    let flow: Flow

    let addtionalFunctions: [Callable]

    var anyCallables: [AnyCallable] { flow.graphs.map({ AnyCallable(graph: $0, delegate: self) }) }

    public init(flow: Flow, addtionalFunctions: [Callable]) {
        self.flow = flow
        self.addtionalFunctions = addtionalFunctions
    }

    public var graphs: [Graph] { flow.graphs }

    public var callableFunctions: [Callable] { anyCallables + addtionalFunctions + Self.functions }

    public subscript(id: Callable.ID) -> Callable? {
        guard let index = callableFunctions.firstIndex(where: { $0.id == id }) else { return nil }
        return callableFunctions[index]
    }
}

public struct Bypass: Callable {

    public var id: ID { Node.Function.bypass }

    public init() { }

    public func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData {

        let portData = output[index]

        switch portData {
            case .bool(_):
                let result = input[index].boolValue
                return .bool(result)
            case .int(_):
                let result = input[index].intValue
                return .int(result)
            case .float(_):
                let result = input[index].floatValue
                return .float(result)
            case .string(_):
                let result = input[index].stringValue
                return .string(result)
            case .boolArray(_):
                let result = input[index].boolArrayValue
                return .boolArray(result)
            case .intArray(_):
                let result = input[index].intArrayValue
                return .intArray(result)
            case .floatArray(_):
                let result = input[index].floatArrayValue
                return .floatArray(result)
            case .stringArray(_):
                let result = input[index].stringArrayValue
                return .stringArray(result)
        }
    }
}

public struct Sum: Callable {

    public var id: ID { Node.Function.sum }

    public init() { }

    public func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData {

        let portData = output[index]

        switch portData {
            case .bool(_):
                let result = input.compactMap({ $0.boolValue }).reduce(false) { $0 || $1 }
                return .bool(result)
            case .int(_):
                let result = input.compactMap({ $0.intValue }).reduce(.zero, +)
                return .int(result)
            case .float(_):
                let result = input.compactMap({ $0.floatValue }).reduce(.zero, +)
                return .float(result)
            case .string(_):
                let result = input.compactMap({ $0.stringValue }).reduce("", +)
                return .string(result)
            case .boolArray(_):
                let values: [[Bool]] = input.compactMap({ $0.boolArrayValue })
                if let first = values.first {
                    if values.count > 1 {
                        let result = values.reduce(Array(repeating: false, count: first.count), { prev, current in
                            return zip(prev, current).map { $0 || $1 }
                        })
                        return .boolArray(result)
                    }
                    return .boolArray(first)
                }
                return .boolArray([])
            case .intArray(_):
                let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                if let first = values.first {
                    if values.count > 1 {
                        let result = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) }).map({ Int($0) })
                        return .intArray(result)
                    }
                    return .intArray(first.map({ Int($0) }))
                }
                return .intArray([])
            case .floatArray(_):
                let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                if let first = values.first {
                    if values.count > 1 {
                        let result = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                        return .floatArray(result)
                    }
                    return .floatArray(first)
                }
                return .floatArray([])
            case .stringArray(_):
                let values: [[String]] = input.compactMap({ $0.stringArrayValue })
                if let first = values.first {
                    if values.count > 1 {
                        let result = values.reduce(Array(repeating: "", count: first.count), { prev, current in
                            return zip(prev, current).map { $0 + $1 }
                        })
                        return .stringArray(result)
                    }
                    return .stringArray(first)
                }
                return .stringArray([])
        }
    }
}

public struct Product: Callable {

    public var id: ID { Node.Function.product }

    public init() { }

    public func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData {

        let portData = output[index]

        switch portData {
            case .bool(_):
                let inputs = input.compactMap({ $0.boolValue })
                if inputs.count > 1 {
                    let result = inputs.reduce(true) { $0 && $1 }
                    return .bool(result)
                }
                return .bool(false)
            case .int(_):
                let inputs = input.compactMap({ $0.intValue })
                if inputs.count > 1 {
                    let result = inputs.reduce(1, *)
                    return .int(result)
                }
                return .int(0)
            case .float(_):
                let inputs = input.compactMap({ $0.floatValue })
                if inputs.count > 1 {
                    let result = inputs.reduce(1, *)
                    return .float(result)
                }
                return .float(0)
            case .string(_):
                return .string(.failure(.convertError))
            case .boolArray(_):
                let values: [[Bool]] = input.compactMap({ $0.boolArrayValue })
                if let first = values.first {
                    if values.count > 1 {
                        let result = values.reduce(Array(repeating: true, count: first.count), { prev, current in
                            return zip(prev, current).map { $0 && $1 }
                        })
                        return .boolArray(result)
                    }
                    return .boolArray(first)
                }
                return .boolArray([])
            case .intArray(_):
                let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                if let first = values.first {
                    if values.count > 1 {
                        let result = values.reduce(Array(repeating: 1, count: first.count), { vDSP.multiply($0, $1) }).map({ Int($0) })
                        return .intArray(result)
                    }
                    return .intArray(first.map({ Int($0) }))
                }
                return .intArray([])
            case .floatArray(_):
                let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                if let first = values.first {
                    if values.count > 1 {
                        let result = values.reduce(Array(repeating: 1, count: first.count), { vDSP.multiply($0, $1) })
                        return .floatArray(result)
                    }
                    return .floatArray(first)
                }
                return .floatArray([])
            case .stringArray(_):
                return .stringArray(.failure(.convertError))
        }
    }
}

public struct Average: Callable {

    public var id: ID { Node.Function.average }

    public init() { }

    public func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData {

        let portData = output[index]

        switch portData {
            case .bool(_):
                return .bool(.failure(.convertError))
            case .int(_):
                let args = input.compactMap({ $0.intValue })
                if args.count == 0 { return .int(.failure(.mathematicalError)) }
                let result = args.reduce(.zero, +) / args.count
                return .int(result)
            case .float(_):
                let args = input.compactMap({ $0.floatValue })
                if args.count == 0 { return .float(.failure(.mathematicalError)) }
                let result = args.reduce(.zero, +) / Float(args.count)
                return .float(result)
            case .string(_):
                return .string(.failure(.convertError))
            case .boolArray(_):
                return .boolArray(.failure(.convertError))
            case .intArray(_):
                let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                if values.count == 0 { return .intArray(.failure(.mathematicalError)) }
                if let first = values.first {
                    if values.count > 1 {
                        let totalValues = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                        let result = vDSP.divide(totalValues, Float(values.count)).map({ Int($0) })
                        return .intArray(result)
                    }
                    return .intArray(first.map({ Int($0) }))
                }
                return .intArray([])
            case .floatArray(_):
                let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                if values.count == 0 { return .floatArray(.failure(.mathematicalError)) }
                if let first = values.first {
                    if values.count > 1 {
                        let totalValues = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                        let result = vDSP.divide(totalValues, Float(values.count))
                        return .floatArray(result)
                    }
                    return .floatArray(first)
                }
                return .floatArray([])
            case .stringArray(_):
                return .stringArray(.failure(.convertError))
        }
    }
}

public struct Varp: Callable {

    public var id: ID { Node.Function.varp }

    public init() { }

    public func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData {

        let portData = output[index]

        switch portData {
            case .bool(_):
                return .bool(.failure(.convertError))
            case .int(_):
                let args = input.compactMap({ $0.intValue })
                if args.count == 0 { return .int(.failure(.mathematicalError)) }
                let average = args.reduce(.zero, +) / args.count
                let result = args.reduce(.zero, { $0 + ($1 - average) * ($1 - average) }) / args.count
                return .int(result)
            case .float(_):
                let args = input.compactMap({ $0.floatValue })
                if args.count == 0 { return .float(.failure(.mathematicalError)) }
                let average = args.reduce(.zero, +) / Float(args.count)
                let result = args.reduce(.zero, { $0 + ($1 - average) * ($1 - average) }) / Float(args.count)
                return .float(result)
            case .string(_):
                return .string(.failure(.convertError))
            case .boolArray(_):
                return .boolArray(.failure(.convertError))
            case .intArray(_):
                let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                if values.count == 0 { return .intArray(.failure(.mathematicalError)) }
                if let first = values.first {
                    if values.count > 1 {
                        let totalValues = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                        let squereValues = values.map({ vDSP.multiply($0, $0) })
                        let squereTotalValues = squereValues.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                        let squereAvarageValues = vDSP.divide(squereTotalValues, Float(values.count))
                        let averageValues = vDSP.divide(totalValues, Float(values.count))
                        let averageSquereValues = vDSP.multiply(averageValues, averageValues)
                        let result = vDSP.subtract(squereAvarageValues, averageSquereValues).map({ Int($0) })
                        return .intArray(result)
                    }
                    return .intArray(Array(repeating: 0, count: first.count))
                }
                return .intArray([])
            case .floatArray(_):
                let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                if values.count == 0 { return .floatArray(.failure(.mathematicalError)) }
                if let first = values.first {
                    if values.count > 1 {
                        let totalValues = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                        let squereValues = values.map({ vDSP.multiply($0, $0) })
                        let squereTotalValues = squereValues.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                        let squereAvarageValues = vDSP.divide(squereTotalValues, Float(values.count))
                        let averageValues = vDSP.divide(totalValues, Float(values.count))
                        let averageSquereValues = vDSP.multiply(averageValues, averageValues)
                        let result = vDSP.subtract(squereAvarageValues, averageSquereValues)
                        return .floatArray(result)
                    }
                    return .floatArray(Array(repeating: 0, count: first.count))
                }
                return .floatArray([])
            case .stringArray(_):
                return .stringArray(.failure(.convertError))
        }
    }
}

