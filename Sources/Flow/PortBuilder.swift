//
//  File.swift
//  
//
//  Created by nori on 2021/06/30.
//

import Foundation

//public protocol Calculatable {
//
//    associatedtype Result
//
//    var result: Result { get }
//}
//
//public struct EmptyItem: Calculatable {
//
//    public typealias Result = Never
//
//    public init() { }
//
//    public var result: Never { fatalError("Something very, very bad happened") }
//}
//
//public struct TupleItem<T>: Calculatable {
//
//    public typealias Result = Never
//
//    public var value: T
//
//    public init(_ value: T) {
//        self.value = value
//    }
//
//    public var result: Never { fatalError("Something very, very bad happened") }
//}
//
//@resultBuilder
//public struct InputPortBuilder {
//
//    public static func buildBlock() -> EmptyItem { EmptyItem() }
//
//    public static func buildBlock<Content>(_ content: Content) -> Content where Content: Calculatable { content }
//}
//
//extension InputPortBuilder {
//
//    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleItem<(C0, C1)> where C0: Calculatable, C1: Calculatable {
//        TupleItem<(C0, C1)>((c0, c1))
//    }
//
//    public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleItem<(C0, C1, C2)> where C0: Calculatable, C1: Calculatable, C2: Calculatable {
//        TupleItem<(C0, C1, C2)>((c0, c1, c2))
//    }
//}
//
//@resultBuilder
//public struct OutputPortBuilder {
//    
//    public static func buildBlock() -> EmptyItem { EmptyItem() }
//
//    public static func buildBlock<Content>(_ content: Content) -> Content where Content: Calculatable { content }
//}

//public protocol APort {
//
//
//}
//
//public struct EmptyPort: APort {
//
//}
//
//public struct Input<T>: APort {
//
//    public var value: T
//
//    public init(_ value: T) {
//        self.value = value
//    }
//}
//
//public struct Output<T>: APort {
//
//    public var value: T
//
//    public init(_ value: T) {
//        self.value = value
//    }
//}
//
//extension PortBuilder {
//
//    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> [Output<(C0, C1)>] where C0: APort, C1: APort {
//        return []
//    }
//}
