//
//  Convertible.swift
//  
//
//  Created by nori on 2021/07/02.
//

import Foundation

public protocol Convertible {

    associatedtype Input

    associatedtype Output

    func callAsFunction(_ input: Input) -> Output
}

public struct Add: Convertible {

    public typealias Input = (Float, Float)

    public typealias Output = Float

    public func callAsFunction(_ input: (Float, Float)) -> Float {
        return input.0 + input.1
    }
}

public struct Input: Convertible {

    public typealias Input = Any

    public typealias Output = Any

    public func callAsFunction(_ input: Input) -> Output {
        return input
    }
}
