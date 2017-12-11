//
//  Value.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/10/17.
//

import Foundation

public enum Value: QueryComponent {
    case string(String)
    case raw(String)
    case data(Data)
    case bool(Bool)
    case null

    public var sql: String {
        return "%@"
    }

    public var arguments: [Value] {
        return [self]
    }
}

public protocol ValueConvertible: ParameterConvertible {
    var sqlValue: Value {get}
}

public protocol RawValueConvertible: ValueConvertible {}

extension RawValueConvertible {
    public var sqlValue: Value {
        return .raw("\(self)")
    }
}

extension ValueConvertible {
    public var sqlParameter: Parameter {
        return .value(self.sqlValue)
    }
}

extension Date: ValueConvertible {
    public var sqlValue: Value {
        return .string(self.iso8601DateTime)
    }
}

extension String: ValueConvertible {
    public var sqlValue: Value {
        return .string(self)
    }
}

extension Bool: ValueConvertible {
    public var sqlValue: Value {
        return .bool(self)
    }
}

extension Data: ValueConvertible {
    public var sqlValue: Value {
        return .data(self)
    }
}

extension Int: RawValueConvertible {}
extension Double: RawValueConvertible {}
extension Float: RawValueConvertible {}
extension Int8: RawValueConvertible {}
extension Int16: RawValueConvertible {}
extension Int32: RawValueConvertible {}
extension Int64: RawValueConvertible {}
extension UInt: RawValueConvertible {}
extension UInt8: RawValueConvertible {}
extension UInt16: RawValueConvertible {}
extension UInt32: RawValueConvertible {}
extension UInt64: RawValueConvertible {}

