//
//  EdgeView.swift
//
//
//  Created by nori on 2021/06/22.
//

import SwiftUI

struct ConnectionView: View {

    var connection: Connection

    var start: CGPoint { connection.start }

    var end: CGPoint { connection.end }

    var body: some View {
        Path { path in
            let x: CGFloat = (end.x - start.x) / 2
            let y: CGFloat = (end.y - start.y) / 2
            let center: CGPoint = CGPoint(x: start.x + x, y: start.y + y)
            path.move(to: start)
            path.addCurve(to: end,
                          control1: CGPoint(x: center.x, y: start.y),
                          control2: CGPoint(x: center.x, y: end.y))
        }
        .stroke(Color.black.opacity(0.2), lineWidth: 2)
    }
}

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
