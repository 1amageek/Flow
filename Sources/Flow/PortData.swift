//
//  PortData.swift
//  
//
//  Created by nori on 2021/06/28.
//

import Foundation

public enum PortData {

    public typealias BoolValue = Result<Bool?, NodeError>
    public typealias IntValue = Result<Int?, NodeError>
    public typealias FloatValue = Result<Float?, NodeError>
    public typealias StringValue = Result<String?, NodeError>

    case bool(BoolValue?)
    case int(IntValue?)
    case float(FloatValue?)
    case string(StringValue?)

    public static func bool(_ value: Bool? = nil, error: NodeError? = nil) -> Self {
        if let error = error { return .bool(.failure(error)) }
        return .bool(.success(value))
    }

    public static func int(_ value: Int? = nil, error: NodeError? = nil) -> Self {
        if let error = error { return .int(.failure(error)) }
        return .int(.success(value))
    }

    public static func float(_ value: Float? = nil, error: NodeError? = nil) -> Self {
        if let error = error { return .float(.failure(error)) }
        return .float(.success(value))
    }

    public static func string(_ value: String? = nil, error: NodeError? = nil) -> Self {
        if let error = error { return .string(.failure(error)) }
        return .string(.success(value))
    }

    public var text: String {
        switch self {
            case .bool(let value):
                guard let value = try? value?.get() else { return "" }
                return "\(value)"
            case .int(let value):
                guard let value = try? value?.get() else { return "" }
                return "\(value)"
            case .float(let value):
                guard let value = try? value?.get() else { return "" }
                return "\(value)"
            case .string(let value):
                guard let value = try? value?.get() else { return "" }
                return value
        }
    }

    public var boolValue: Bool? {
        switch self {
            case .bool(let value):
                guard let value = try? value?.get() else { return nil }
                return value
            case .int(let value):
                guard let value = try? value?.get() else { return nil }
                return value != 0
            case .float(let value):
                guard let value = try? value?.get() else { return nil }
                return value != 0
            case .string(let value):
                guard let value = try? value?.get() else { return nil }
                if value == "true" { return true }
                if value == "false" { return false }
                return nil
        }
    }

    public var intValue: Int? {
        switch self {
            case .bool(let value):
                guard let value = try? value?.get() else { return nil }
                return value ? 1 : 0
            case .int(let value):
                guard let value = try? value?.get() else { return nil }
                return value
            case .float(let value):
                guard let value = try? value?.get() else { return nil }
                return Int(value)
            case .string(let value):
                guard let value = try? value?.get() else { return nil }
                return Int(value)
        }
    }

    public var floatValue: Float? {
        switch self {
            case .bool(let value):
                guard let value = try? value?.get() else { return nil }
                return value ? 1.0 : 0.0
            case .int(let value):
                guard let value = try? value?.get() else { return nil }
                return Float(value)
            case .float(let value):
                guard let value = try? value?.get() else { return nil }
                return value
            case .string(let value):
                guard let value = try? value?.get() else { return nil }
                return Float(value)
        }
    }

    public var stringValue: String? {
        switch self {
            case .bool(let value):
                guard let value = try? value?.get() else { return nil }
                return String(value)
            case .int(let value):
                guard let value = try? value?.get() else { return nil }
                return String(value)
            case .float(let value):
                guard let value = try? value?.get() else { return nil }
                return String(value)
            case .string(let value):
                guard let value = try? value?.get() else { return nil }
                return value
        }
    }
}
