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
        id: String,
        name: String,
        inputs: [Interface] = [],
        outputType: PortData,
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(Function.sum), id: id, name: name, inputs: inputs, outputs: [Interface(outputType)], position: position)
    }

    public static func product(
        id: String,
        name: String,
        inputs: [Interface] = [],
        outputType: PortData,
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(Function.product), id: id, name: name, inputs: inputs, outputs: [Interface(outputType)], position: position)
    }

    public static func average(
        id: String,
        name: String,
        inputs: [Interface] = [],
        outputType: PortData,
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(Function.average), id: id, name: name, inputs: inputs, outputs: [Interface(outputType)], position: position)
    }

    public static func varp(
        id: String,
        name: String,
        inputs: [Interface] = [],
        outputType: PortData,
        position: CGPoint = .zero
    ) -> Node {
        Node(type: .io(Function.varp), id: id, name: name, inputs: inputs, outputs: [Interface(outputType)], position: position)
    }

}

