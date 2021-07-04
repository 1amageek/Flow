//
//  EdgeShape.swift
//  
//
//  Created by nori on 2021/07/04.
//

import SwiftUI

public struct EdgeShape: Shape {

    var start: CGPoint

    var end: CGPoint

    public init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }

    public func path(in rect: CGRect) -> Path {
        Path { path in
            let x: CGFloat = (end.x - start.x) / 2
            let y: CGFloat = (end.y - start.y) / 2
            let center: CGPoint = CGPoint(x: start.x + x, y: start.y + y)
            path.move(to: start)
            path.addCurve(to: end,
                          control1: CGPoint(x: center.x, y: start.y),
                          control2: CGPoint(x: center.x, y: end.y))
        }
    }
}
