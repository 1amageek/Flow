//
//  Node.swift
//  
//
//  Created by nori on 2021/06/21.
//

import Foundation
import CoreGraphics

public struct Node<Data: Codable>: Identifiable, GeomertryProperties, Codable {
    
    public var id: String

    public var title: String

    public var position: CGPoint = .zero

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public var inputs: [InputPort<Data>] = []

    public var outputs: [OutputPort<Data>] = []

    public init(
        id: String,
        title: String,
        position: CGPoint,
        inputs: [InputPort<Data>] = [],
        outputs: [OutputPort<Data>] = []
    ) {
        self.id = id
        self.title = title
        self.position = position
        self.inputs = inputs
        self.outputs = outputs
    }
}
