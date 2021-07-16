//
//  Canvas.swift
//  
//
//  Created by nori on 2021/07/03.
//

import Foundation
import CoreGraphics

struct Canvas: Codable {

    var sacle: CGFloat = 1

    var offset: CGSize = .zero

    var size: CGSize = .zero

    var frame: CGRect { CGRect(origin: CGPoint(x: -offset.width, y: -offset.height), size: size) }
}
