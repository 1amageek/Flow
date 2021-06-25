//
//  GeomertryProperties.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation
import CoreGraphics

public protocol GeomertryProperties: Codable {

    var position: CGPoint { get set }

    var offset: CGSize { get set }

    var size: CGSize { get set }

    var frame: CGRect { get }

}

public extension GeomertryProperties {

    var frame: CGRect {
        CGRect(
            x: position.x - size.width / 2,
            y: position.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }
}
