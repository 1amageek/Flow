//
//  Node+Convertible.swift
//  
//
//  Created by nori on 2021/07/03.
//

import Foundation
import CoreGraphics

extension Node {

    public static func sum(
        type: PortData,
        id: String,
        title: String,
        position: CGPoint = .zero,
        inputs: [Interface] = []
    ) -> Node {
        Node(type: .io, id: id, title: title, position: position, inputs: inputs, outputs: [Interface(type)]) { input in
            switch type {
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
            }
        }
    }

    public static func product(
        type: PortData,
        id: String,
        title: String,
        position: CGPoint = .zero,
        inputs: [Interface] = []
    ) -> Node {
        Node(type: .io, id: id, title: title, position: position, inputs: inputs, outputs: [Interface(type)]) { input in
            switch type {
                case .bool(_):
                    let result = input.compactMap({ $0.boolValue }).reduce(false) { $0 && $1 }
                    return [.bool(result)]
                case .int(_):
                    let result = input.compactMap({ $0.intValue }).reduce(.zero, *)
                    return [.int(result)]
                case .float(_):
                    let result = input.compactMap({ $0.floatValue }).reduce(.zero, *)
                    return [.float(result)]
                case .string(_):
                    return [.string(.failure(.convertError))]
            }
        }
    }

    public static func average(
        type: PortData,
        id: String,
        title: String,
        position: CGPoint = .zero,
        inputs: [Interface] = []
    ) -> Node {
        Node(type: .io, id: id, title: title, position: position, inputs: inputs, outputs: [Interface(type)]) { input in
            switch type {
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
            }
        }
    }

    public static func `var`(
        type: PortData,
        id: String,
        title: String,
        position: CGPoint = .zero,
        inputs: [Interface] = []
    ) -> Node {
        Node(type: .io, id: id, title: title, position: position, inputs: inputs, outputs: [Interface(type)]) { input in
            switch type {
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
            }
        }
    }

}
