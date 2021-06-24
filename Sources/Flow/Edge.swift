//
//  Edge.swift
//  
//
//  Created by nori on 2021/06/22.
//

import CoreGraphics


public struct Connection: Identifiable {

    public var id: String

    public var start: CGPoint = .zero

    public var end: CGPoint = .zero

    public var startAddress: Address

    public var endAddress: Address?

    public init(
        id: String,
        start: CGPoint = .zero,
        end: CGPoint = .zero,
        startAddress: Address,
        endAddress: Address? = nil
    ) {
        self.id = id
        self.start = start
        self.end = end
        self.startAddress = startAddress
        self.endAddress = endAddress
    }
}


public struct Edge: Identifiable {

    public var id: String

    public var source: Address

    public var target: Address

    public init(
        id: String,
        source: Address,
        target: Address
    ) {
        self.id = id
        self.source = source
        self.target = target
    }
}
