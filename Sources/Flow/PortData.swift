//
//  File.swift
//  
//
//  Created by nori on 2021/06/28.
//

import Foundation


public enum PortData: Equatable {

    case bool(Bool?)
    case int(Int?)
    case float(Float?)
    case string(String?)

    public var text: String {
        switch self {
            case .bool(let value):
                guard let value = value else { return "" }
                return "\(value)"
            case .int(let value):
                guard let value = value else { return "" }
                return "\(value)"
            case .float(let value):
                guard let value = value else { return "" }
                return "\(value)"
            case .string(let value):
                guard let value = value else { return "" }
                return value
        }
    }

    public var boolValue: Bool? {
        switch self {
            case .bool(let value):
                guard let value = value else { return nil }
                return value
            case .int(let value):
                guard let value = value else { return nil }
                return value != 0
            case .float(let value):
                guard let value = value else { return nil }
                return value != 0
            case .string(let value):
                guard let value = value else { return nil }
                if value == "true" { return true }
                if value == "false" { return false }
                return nil
        }
    }

    public var intValue: Int? {
        switch self {
            case .bool(let value):
                guard let value = value else { return nil }
                return value ? 1 : 0
            case .int(let value):
                guard let value = value else { return nil }
                return value
            case .float(let value):
                guard let value = value else { return nil }
                return Int(value)
            case .string(let value):
                guard let value = value else { return nil }
                return Int(value)
        }
    }

    public var floatValue: Float? {
        switch self {
            case .bool(let value):
                guard let value = value else { return nil }
                return value ? 1.0 : 0.0
            case .int(let value):
                guard let value = value else { return nil }
                return Float(value)
            case .float(let value):
                guard let value = value else { return nil }
                return value
            case .string(let value):
                guard let value = value else { return nil }
                return Float(value)
        }
    }

    public var stringValue: String? {
        switch self {
            case .bool(let value):
                guard let value = value else { return nil }
                return String(value)
            case .int(let value):
                guard let value = value else { return nil }
                return String(value)
            case .float(let value):
                guard let value = value else { return nil }
                return String(value)
            case .string(let value):
                guard let value = value else { return nil }
                return value
        }
    }
}
