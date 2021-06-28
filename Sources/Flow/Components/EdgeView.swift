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

struct EdgeView<NodeElement: Node>: View {

    @EnvironmentObject var context: Graph<NodeElement>

    var edge: Edge

    var start: CGPoint { context.sourcePosition(address: edge.source) ?? .zero }

    var end: CGPoint { context.targetPosition(address: edge.target) ?? .zero }

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
        .stroke(Color.black.opacity(0.4), lineWidth: 2)
    }
}
