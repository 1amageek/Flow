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

    func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData
}

extension Callable {

    func callAsFunction(input: Input, output: Output) -> [PortData] {
        return output.enumerated().map { index, _ in
            return self(input: input, output: output, index: index)
        }
    }
}


public struct SampleFunc: Callable {

    public var id: ID { "SampleFunc" }

    public func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData {
        return PortData.bool(.success(true))
    }

    public init() {

    }
}

public struct SampleFuncB: Callable {

    public var id: ID { "SampleFunc" }

    public func callAsFunction(input: Input, output: Output, index: PortIndex) -> PortData {
        return PortData.bool(.success(true))
    }

    public init() {

    }
}
