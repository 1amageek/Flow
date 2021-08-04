//
//  Cluster.swift
//  Cluster
//
//  Created by nori on 2021/07/25.
//

import SwiftUI

public struct Cluster: Codable {

    public var graphs: [Graph]

    public init(graphs: [Graph] = []) {
        self.graphs = graphs
    }
}

