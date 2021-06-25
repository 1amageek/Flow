//
//  Address.swift
//  
//
//  Created by nori on 2021/06/24.
//

import Foundation

public struct Address: Hashable, Codable {

    public var nodeID: String

    public var portID: String

    public init(nodeID: String, portID: String) {
        self.nodeID = nodeID
        self.portID = portID
    }
}
