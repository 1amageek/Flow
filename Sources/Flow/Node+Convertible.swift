//
//  Node+Convertible.swift
//  
//
//  Created by nori on 2021/07/03.
//

import Foundation
import CoreGraphics
import Accelerate

extension Node {

    public static func sum(
        _ type: String? = nil,
        portData: PortData,
        id: String,
        name: String,
        inputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(type), id: id, name: name, inputs: inputs, outputs: [Interface(portData)], position: position) { input in
            switch portData {
                case .bool(_):
                    let result = input.compactMap({ $0.boolValue }).reduce(false) { $0 || $1 }
                    return [.bool(result)]
                case .int(_):
                    let result = input.compactMap({ $0.intValue }).reduce(.zero, +)
                    return [.int(result)]
                case .float(_):
                    let result = input.compactMap({ $0.floatValue }).reduce(.zero, +)
                    return [.float(result)]
                case .string(_):
                    let result = input.compactMap({ $0.stringValue }).reduce("", +)
                    return [.string(result)]
                case .boolArray(_):
                    let values: [[Bool]] = input.compactMap({ $0.boolArrayValue })
                    if let first = values.first {
                        if values.count > 1 {
                            let result = values.reduce(Array(repeating: false, count: first.count), { prev, current in
                                return zip(prev, current).map { $0 || $1 }
                            })
                            return [.boolArray(result)]
                        }
                        return [.boolArray(first)]
                    }
                    return [.boolArray([])]
                case .intArray(_):
                    let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                    if let first = values.first {
                        if values.count > 1 {
                            let result = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) }).map({ Int($0) })
                            return [.intArray(result)]
                        }
                        return [.intArray(first.map({ Int($0) }))]
                    }
                    return [.intArray([])]
                case .floatArray(_):
                    let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                    if let first = values.first {
                        if values.count > 1 {
                            let result = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                            return [.floatArray(result)]
                        }
                        return [.floatArray(first)]
                    }
                    return [.floatArray([])]
                case .stringArray(_):
                    let values: [[String]] = input.compactMap({ $0.stringArrayValue })
                    if let first = values.first {
                        if values.count > 1 {
                            let result = values.reduce(Array(repeating: "", count: first.count), { prev, current in
                                return zip(prev, current).map { $0 + $1 }
                            })
                            return [.stringArray(result)]
                        }
                        return [.stringArray(first)]
                    }
                    return [.stringArray([])]
            }
        }
    }

    public static func product(
        _ type: String? = nil,
        portData: PortData,
        id: String,
        name: String,
        inputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(type), id: id, name: name, inputs: inputs, outputs: [Interface(portData)], position: position) { input in
            switch portData {
                case .bool(_):
                    let result = input.compactMap({ $0.boolValue }).reduce(true) { $0 && $1 }
                    return [.bool(result)]
                case .int(_):
                    let result = input.compactMap({ $0.intValue }).reduce(1, *)
                    return [.int(result)]
                case .float(_):
                    let result = input.compactMap({ $0.floatValue }).reduce(1, *)
                    return [.float(result)]
                case .string(_):
                    return [.string(.failure(.convertError))]
                case .boolArray(_):
                    let values: [[Bool]] = input.compactMap({ $0.boolArrayValue })
                    if let first = values.first {
                        if values.count > 1 {
                            let result = values.reduce(Array(repeating: true, count: first.count), { prev, current in
                                return zip(prev, current).map { $0 && $1 }
                            })
                            return [.boolArray(result)]
                        }
                        return [.boolArray(first)]
                    }
                    return [.boolArray([])]
                case .intArray(_):
                    let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                    if let first = values.first {
                        if values.count > 1 {
                            let result = values.reduce(Array(repeating: 1, count: first.count), { vDSP.multiply($0, $1) }).map({ Int($0) })
                            return [.intArray(result)]
                        }
                        return [.intArray(first.map({ Int($0) }))]
                    }
                    return [.intArray([])]
                case .floatArray(_):
                    let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                    if let first = values.first {
                        if values.count > 1 {
                            let result = values.reduce(Array(repeating: 1, count: first.count), { vDSP.multiply($0, $1) })
                            return [.floatArray(result)]
                        }
                        return [.floatArray(first)]
                    }
                    return [.floatArray([])]
                case .stringArray(_):
                    return [.stringArray(.failure(.convertError))]
            }
        }
    }

    public static func average(
        _ type: String? = nil,
        portData: PortData,
        id: String,
        name: String,
        inputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(type), id: id, name: name, inputs: inputs, outputs: [Interface(portData)], position: position) { input in
            switch portData {
                case .bool(_):
                    return [.bool(.failure(.convertError))]
                case .int(_):
                    let args = input.compactMap({ $0.intValue })
                    if args.count == 0 { return [.int(.failure(.mathematicalError))] }
                    let result = args.reduce(.zero, +) / args.count
                    return [.int(result)]
                case .float(_):
                    let args = input.compactMap({ $0.floatValue })
                    if args.count == 0 { return [.float(.failure(.mathematicalError))] }
                    let result = args.reduce(.zero, +) / Float(args.count)
                    return [.float(result)]
                case .string(_):
                    return [.string(.failure(.convertError))]
                case .boolArray(_):
                    return [.boolArray(.failure(.convertError))]
                case .intArray(_):
                    let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                    if values.count == 0 { return [.intArray(.failure(.mathematicalError))] }
                    if let first = values.first {
                        if values.count > 1 {
                            let totalValues = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                            let result = vDSP.divide(totalValues, Float(values.count)).map({ Int($0) })
                            return [.intArray(result)]
                        }
                        return [.intArray(first.map({ Int($0) }))]
                    }
                    return [.intArray([])]
                case .floatArray(_):
                    let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                    if values.count == 0 { return [.floatArray(.failure(.mathematicalError))] }
                    if let first = values.first {
                        if values.count > 1 {
                            let totalValues = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                            let result = vDSP.divide(totalValues, Float(values.count))
                            return [.floatArray(result)]
                        }
                        return [.floatArray(first)]
                    }
                    return [.floatArray([])]
                case .stringArray(_):
                    return [.stringArray(.failure(.convertError))]
            }
        }
    }

    public static func varp(
        _ type: String? = nil,
        portData: PortData,
        id: String,
        name: String,
        inputs: [Interface] = [],
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(type), id: id, name: name, inputs: inputs, outputs: [Interface(portData)], position: position) { input in
            switch portData {
                case .bool(_):
                    return [.bool(.failure(.convertError))]
                case .int(_):
                    let args = input.compactMap({ $0.intValue })
                    if args.count == 0 { return [.int(.failure(.mathematicalError))] }
                    let average = args.reduce(.zero, +) / args.count
                    let result = args.reduce(.zero, { $0 + ($1 - average) * ($1 - average) }) / args.count
                    return [.int(result)]
                case .float(_):
                    let args = input.compactMap({ $0.floatValue })
                    if args.count == 0 { return [.float(.failure(.mathematicalError))] }
                    let average = args.reduce(.zero, +) / Float(args.count)
                    let result = args.reduce(.zero, { $0 + ($1 - average) * ($1 - average) }) / Float(args.count)
                    return [.float(result)]
                case .string(_):
                    return [.string(.failure(.convertError))]
                case .boolArray(_):
                    return [.boolArray(.failure(.convertError))]
                case .intArray(_):
                    let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                    if values.count == 0 { return [.intArray(.failure(.mathematicalError))] }
                    if let first = values.first {
                        if values.count > 1 {
                            let totalValues = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                            let squereValues = values.map({ vDSP.multiply($0, $0) })
                            let squereTotalValues = squereValues.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                            let squereAvarageValues = vDSP.divide(squereTotalValues, Float(values.count))
                            let averageValues = vDSP.divide(totalValues, Float(values.count))
                            let averageSquereValues = vDSP.multiply(averageValues, averageValues)
                            let result = vDSP.subtract(squereAvarageValues, averageSquereValues).map({ Int($0) })
                            return [.intArray(result)]
                        }
                        return [.intArray(Array(repeating: 0, count: first.count))]
                    }
                    return [.intArray([])]
                case .floatArray(_):
                    let values: [[Float]] = input.compactMap({ $0.floatArrayValue })
                    if values.count == 0 { return [.floatArray(.failure(.mathematicalError))] }
                    if let first = values.first {
                        if values.count > 1 {
                            let totalValues = values.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                            let squereValues = values.map({ vDSP.multiply($0, $0) })
                            let squereTotalValues = squereValues.reduce(Array(repeating: 0, count: first.count), { vDSP.add($0, $1) })
                            let squereAvarageValues = vDSP.divide(squereTotalValues, Float(values.count))
                            let averageValues = vDSP.divide(totalValues, Float(values.count))
                            let averageSquereValues = vDSP.multiply(averageValues, averageValues)
                            let result = vDSP.subtract(squereAvarageValues, averageSquereValues)
                            return [.floatArray(result)]
                        }
                        return [.floatArray(Array(repeating: 0, count: first.count))]
                    }
                    return [.floatArray([])]
                case .stringArray(_):
                    return [.stringArray(.failure(.convertError))]
            }
        }
    }

}

