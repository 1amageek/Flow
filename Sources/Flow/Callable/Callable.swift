//
//  Callable.swift
//  
//
//  Created by nori on 2021/07/13.
//

import Foundation

public protocol Callable {

    typealias Input = [PortData]

    typealias Output = [PortData]

    typealias ID = String

    var id: ID { get }

    func callAsFunction(_ input: Input, _ output: Output) -> [PortData]

    func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData
}

extension Callable {

    public func callAsFunction(_ input: Input, _ output: Output) -> [PortData] {
        return output.enumerated().map { index, _ in
            return self(input: input, output: output, index: index)
        }
    }
}
