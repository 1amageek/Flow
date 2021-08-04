//
//  Flow.swift
//  Flow
//
//  Created by nori on 2021/07/25.
//

import SwiftUI

public struct Flow: Codable {

    public var graphs: [Graph] = []

    public init(graphs: [Graph]) {
        self.graphs = graphs
    }
}


extension Flow {
    public static var placeholder: Self { Flow(graphs: [Graph.placeholder]) }
}
