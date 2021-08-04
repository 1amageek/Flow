//
//  Flow+Placeholder.swift
//  Flow+Placeholder
//
//  Created by nori on 2021/08/04.
//

import Foundation
import Flow
import CoreGraphics


extension Cluster {
    public static var placeholder: Self { Cluster(graphs: [Graph.placeholder]) }
}

extension Graph {
    public static var placeholder: Self {
        Graph(
            nodes: [
                .input(id: "R", name: "R", inputs: [.float(name: "R")], position: CGPoint(x: 200, y: 200)),
                .input(id: "G", name: "G", inputs: [.float(name: "B")], position: CGPoint(x: 200, y: 400)),
                .input(id: "B", name: "B", inputs: [.float(name: "B")], position: CGPoint(x: 200, y: 600)),
                .sum(id: "SUM", name: "SUM", inputs: [.float(), .float(), .float()], outputType: .float(), position: CGPoint(x: 400, y: 400)),
                .output(id: "OUT", name: "OUT", outputs: [.float()], position: CGPoint(x: 650, y: 400)),

                    .input(id: "DATAA", name: "DATA A", inputs: [.floatArray([1, 2, 3, 4], name: "R")], position: CGPoint(x: 200, y: 900)),
                .input(id: "DATAB", name: "DATA B", inputs: [.floatArray([1, 2, 3, 4], name: "R")], position: CGPoint(x: 200, y: 1100)),
                .product(id: "PRODUCT", name: "PRODUCT", inputs: [.floatArray(), .floatArray()], outputType: .float(), position: CGPoint(x: 400, y: 1000)),

            ],
            edges: [
                Edge(source: .output("R", index: 0), target: .input("SUM", index: 0)),
                Edge(source: .output("G", index: 0), target: .input("SUM", index: 1)),
                Edge(source: .output("B", index: 0), target: .input("SUM", index: 2)),
                Edge(source: .output("SUM", index: 0), target: .input("OUT", index: 0)),

                Edge(source: .output("DATAA", index: 0), target: .input("PRODUCT", index: 0)),
                Edge(source: .output("DATAB", index: 0), target: .input("PRODUCT", index: 1)),
            ])
    }
}

