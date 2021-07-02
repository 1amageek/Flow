//
//  Address.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation

public struct Address: Hashable {

    public enum Port: Hashable {

        case input(PortIndex)
        case output(PortIndex)

        public var index: PortIndex {
            switch self {
                case .input(let index): return index
                case .output(let index): return index
            }
        }
    }

    public var id: String

    public var port: Port

    public init(id: String, port: Port) {
        self.id = id
        self.port = port
    }
}
