//
//  Canvas.swift
//  
//
//  Created by nori on 2021/07/03.
//

import Foundation
import CoreGraphics

public struct Canvas: Codable {

    public var scale: CGFloat = 1

    public var offset: CGSize = .zero

    public var size: CGSize = .zero

    public var frame: CGRect { CGRect(origin: CGPoint(x: -offset.width, y: -offset.height), size: size) }

    var visibleFrame: CGRect {
        if scale == 1 { return CGRect(origin: CGPoint(x: -offset.width, y: -offset.height), size: size) }
        let width = size.width / scale
        let height = size.height / scale
        let deltaX = (width - size.width) / 2
        let deltaY = (height - size.height) / 2
        return CGRect(
            x: -offset.width - deltaX,
            y: -offset.height - deltaY,
            width: width,
            height: height
        )
    }
}
