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

