//
//  EdgeView.swift
//  
//
//  Created by nori on 2021/06/22.
//

import SwiftUI

struct ConnectionView: View {

    @EnvironmentObject var context: CanvasContext

    var connection: Connection

    var start: CGPoint { connection.start }

    var end: CGPoint { connection.end }

    var body: some View {
        Path { path in
//            print(start, end, edge.source, edge.target, context.portFrames)
            let x: CGFloat = (end.x - start.x) / 2
            let y: CGFloat = (end.y - start.y) / 2
            let center: CGPoint = CGPoint(x: x, y: y)
            path.move(to: start)
            path.addLine(to: end)
//            path.addCurve(to: end,
//                          control1: CGPoint(x: center.x, y: start.y),
//                          control2: CGPoint(x: center.x, y: end.y))
        }
        .stroke(lineWidth: 4)
    }
}

struct EdgeView: View {

    @EnvironmentObject var context: CanvasContext

    var edge: Edge

    var start: CGPoint { context.portPosition(at: edge.source) ?? .zero }

    var end: CGPoint { context.portPosition(at: edge.target) ?? .zero }

    var body: some View {
        Path { path in
//            print(start, end, edge.source, edge.target, context.portFrames)
            let x: CGFloat = (end.x - start.x) / 2
            let y: CGFloat = (end.y - start.y) / 2
            let center: CGPoint = CGPoint(x: x, y: y)
            path.move(to: start)
            path.addLine(to: end)
//            path.addCurve(to: end,
//                          control1: CGPoint(x: center.x, y: start.y),
//                          control2: CGPoint(x: center.x, y: end.y))
        }
        .stroke(lineWidth: 2)
    }
}

//struct EdgeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EdgeView(edge:
//                    Edge(id: "1",
//                         start: .zero,
//                         end: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height),
//                         startConnectoin: Edge.Connection(nodeID: "", portID: "")
//                        ))
//            .ignoresSafeArea()
//    }
//}
