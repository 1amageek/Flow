//
//  PortData.swift
//  
//
//  Created by nori on 2021/06/28.
//

import Foundation

public enum PortData: Hashable {

    public typealias BoolValue = Result<Bool?, NodeError>
    public typealias IntValue = Result<Int?, NodeError>
    public typealias FloatValue = Result<Float?, NodeError>
    public typealias StringValue = Result<String?, NodeError>
    public typealias BoolArray = Result<[Bool]?, NodeError>
    public typealias IntArray = Result<[Int]?, NodeError>
    public typealias FloatArray = Result<[Float]?, NodeError>
    public typealias StringArray = Result<[String]?, NodeError>

    case bool(BoolValue?)
    case int(IntValue?)
    case float(FloatValue?)
    case string(StringValue?)
    case boolArray(BoolArray?)
    case intArray(IntArray?)
    case floatArray(FloatArray?)
    case stringArray(StringArray?)

    public var isArray: Bool {
        switch self {
            case .boolArray(_): return true
            case .intArray(_): return true
            case .floatArray(_): return true
            case .stringArray(_): return true
            default: return false
        }
    }

    public var exists: Bool {
        switch self {
            case .bool(let value):
                guard let _ = try? value?.get() else { return false }
                return true
            case .int(let value):
                guard let _ = try? value?.get() else { return false }
                return true
            case .float(let value):
                guard let _ = try? value?.get() else { return false }
                return true
            case .string(let value):
                guard let _ = try? value?.get() else { return false }
                return true
            case .boolArray(let value):
                guard let _ = try? value?.get() else { return false }
                return true
            case .intArray(let value):
                guard let _ = try? value?.get() else { return false }
                return true
            case .floatArray(let value):
                guard let _ = try? value?.get() else { return false }
                return true
            case .stringArray(let value):
                guard let _ = try? value?.get() else { return false }
                return true
        }
    }

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

    public static func boolArray(_ value: [Bool]? = nil, error: NodeError? = nil) -> Self {
        if let error = error { return .boolArray(.failure(error)) }
        return .boolArray(.success(value))
    }

    public static func intArray(_ value: [Int]? = nil, error: NodeError? = nil) -> Self {
        if let error = error { return .intArray(.failure(error)) }
        return .intArray(.success(value))
    }

    public static func floatArray(_ value: [Float]? = nil, error: NodeError? = nil) -> Self {
        if let error = error { return .floatArray(.failure(error)) }
        return .floatArray(.success(value))
    }

    public static func stringArray(_ value: [String]? = nil, error: NodeError? = nil) -> Self {
        if let error = error { return .stringArray(.failure(error)) }
        return .stringArray(.success(value))
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
                if value == "true" || value == "TRUE" { return true }
                if value == "false" || value == "FALSE" { return false }
                return nil
            default: return nil
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
            default: return nil
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
            default: return nil
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
            default: return nil
        }
    }

    public var boolArrayValue: [Bool]? {
        switch self {
            case .bool(let value):
                guard let value = try? value?.get() else { return nil }
                return [value]
            case .int(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value != 0
                return [result]
            case .float(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value != 0
                return [result]
            case .string(let value):
                guard let value = try? value?.get() else { return nil }
                if value == "true" || value == "TRUE" { return [true] }
                if value == "false" || value == "FALSE" { return [false] }
                return nil
            case .boolArray(let value):
                guard let value = try? value?.get() else { return nil }
                return value
            case .intArray(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value.map({ $0 != 0 })
                return result
            case .floatArray(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value.map({ $0 != 0 })
                return result
            case .stringArray(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value.map({ value -> Bool in
                    if value == "true" || value == "TRUE" {
                        return true
                    } else {
                        return false
                    }
                })
                return result
        }
    }

    public var intArrayValue: [Int]? {
        switch self {
            case .bool(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value ? 1 : 0
                return [result]
            case .int(let value):
                guard let value = try? value?.get() else { return nil }
                return [value]
            case .float(let value):
                guard let value = try? value?.get() else { return nil }
                return [Int(value)]
            case .string(let value):
                guard let value = try? value?.get() else { return nil }
                guard let result = Int(value) else { return nil }
                return [result]
            case .boolArray(let value):
                guard let value = try? value?.get() else { return nil }
                return value.map({ $0 ? 1 : 0 })
            case .intArray(let value):
                guard let value = try? value?.get() else { return nil }
                return value
            case .floatArray(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value.map({ Int($0) })
                return result
            case .stringArray(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value.map({ Int($0) ?? 0 })
                return result
        }
    }

    public var floatArrayValue: [Float]? {
        switch self {
            case .bool(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value ? 1.0 : 0.0
                return [Float(result)]
            case .int(let value):
                guard let value = try? value?.get() else { return nil }
                return [Float(value)]
            case .float(let value):
                guard let value = try? value?.get() else { return nil }
                return [value]
            case .string(let value):
                guard let value = try? value?.get() else { return nil }
                guard let result = Float(value) else { return nil }
                return [result]
            case .boolArray(let value):
                guard let value = try? value?.get() else { return nil }
                return value.map({ $0 ? 1 : 0 })
            case .intArray(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value.map({ Float($0) })
                return result
            case .floatArray(let value):
                guard let value = try? value?.get() else { return nil }
                return value
            case .stringArray(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value.map({ Float($0) ?? 0 })
                return result
        }
    }

    public var stringArrayValue: [String]? {
        switch self {
            case .bool(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value ? 1.0 : 0.0
                return [String(result)]
            case .int(let value):
                guard let value = try? value?.get() else { return nil }
                return [String(value)]
            case .float(let value):
                guard let value = try? value?.get() else { return nil }
                return [String(value)]
            case .string(let value):
                guard let value = try? value?.get() else { return nil }
                return [value]
            case .boolArray(let value):
                guard let value = try? value?.get() else { return nil }
                return value.map({ String($0) })
            case .intArray(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value.map({ String($0) })
                return result
            case .floatArray(let value):
                guard let value = try? value?.get() else { return nil }
                let result = value.map({ String($0) })
                return result
            case .stringArray(let value):
                guard let value = try? value?.get() else { return nil }
                return value
        }
    }
}

extension PortData: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
            case .bool(let value):
                guard let value = try? value?.get() else {
                    return "Bool(nil)"
                }
                return "Bool(\(value))"
            case .int(let value):
                guard let value = try? value?.get() else {
                    return "Int(nil)"
                }
                return "Int(\(value))"
            case .float(let value):
                guard let value = try? value?.get() else {
                    return "Float(nil)"
                }
                return "Float(\(value))"
            case .string(let value):
                guard let value = try? value?.get() else {
                    return "String(nil)"
                }
                return "String(\(value))"
            case .boolArray(let value):
                guard let value = try? value?.get() else {
                    return "[Bool](nil)"
                }
                return "[Bool](\(value))"
            case .intArray(let value):
                guard let value = try? value?.get() else {
                    return "[Int](nil)"
                }
                return "[Int](\(value))"
            case .floatArray(let value):
                guard let value = try? value?.get() else {
                    return "[Float](nil)"
                }
                return "[Float](\(value))"
            case .stringArray(let value):
                guard let value = try? value?.get() else {
                    return "[String](nil)"
                }
                return "[String](\(value))"
        }
    }

}
