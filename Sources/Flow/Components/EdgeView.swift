//
//  EdgeView.swift
//
//
//  Created by nori on 2021/06/22.
//

import SwiftUI

public struct EdgeView: View {

    @EnvironmentObject var context: Graph

    var edge: Edge

    var start: CGPoint { context.position(with: edge.source) ?? .zero }

    var end: CGPoint { context.position(with: edge.target) ?? .zero }

    public init(_ edge: Edge) {
        self.edge = edge
    }

    public var body: some View {
        EdgeShape(start: start, end: end)
            .stroke(Color(.systemGray), lineWidth: 2)
    }
}
