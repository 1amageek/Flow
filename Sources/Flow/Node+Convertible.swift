//
//  File.swift
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
                    let result = input.compactMap({ $0.boolValue }).reduce(false) { prev, current in
                        return prev || current
                    }
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
}
