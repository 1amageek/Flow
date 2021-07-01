//
//  File.swift
//  
//
//  Created by nori on 2021/06/28.
//

import Foundation


public enum PortData {

    case none
    case int(Int)
    case float(Float)
    case string(String)

    public var text: String {
        switch self {
            case .none: return ""
            case .int(let value): return "\(value)"
            case .float(let value): return "\(value)"
            case .string(let string): return string
        }
    }
}
