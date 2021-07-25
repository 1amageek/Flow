//
//  UTType+Flow.swift
//  UTType+Flow
//
//  Created by nori on 2021/07/15.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {

    public static let flow = UTType(exportedAs: "inc.stamp.flow")

    public static let graph = UTType(exportedAs: "inc.stamp.flow.graph")

    public static let node = UTType(exportedAs: "inc.stamp.flow.node")

    public static let edge = UTType(exportedAs: "inc.stamp.flow.edge")

}
