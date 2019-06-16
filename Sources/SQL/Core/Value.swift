//
//  Value.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/10/17.
//

import Foundation

public enum Value: QueryComponent {
    case string(String)

    case float(Float)
    case double(Double)

    case int(Int)
    case int8(Int8)
    case int16(Int16)
    case int32(Int32)
    case int64(Int64)

    case uint(UInt)
    case uint8(UInt8)
    case uint16(UInt16)
    case uint32(UInt32)
    case uint64(UInt64)

    case data(Data)
    case bool(Bool)
    case null

    case point(x: Float, y: Float)
    case time(hour: Int, minute: Int, second: Int)

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

extension ValueConvertible {
    public var sqlParameter: Parameter {
        return .value(self.sqlValue)
    }
}

extension Date: ValueConvertible {
    public var sqlValue: Value {
        return .string(self.iso8601DateTime)
    }

    public var localSqlValue: Value {
        return .string(self.localIso8601DateTime)
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

extension Int: ValueConvertible {
    public var sqlValue: Value {
        return .int(self)
    }
}

extension Double: ValueConvertible {
    public var sqlValue: Value {
        return .double(self)
    }
}

extension Float: ValueConvertible {
    public var sqlValue: Value {
        return .float(self)
    }
}

extension Int8: ValueConvertible {
    public var sqlValue: Value {
        return .int8(self)
    }
}

extension Int16: ValueConvertible {
    public var sqlValue: Value {
        return .int16(self)
    }
}

extension Int32: ValueConvertible {
    public var sqlValue: Value {
        return .int32(self)
    }
}

extension Int64: ValueConvertible {
    public var sqlValue: Value {
        return .int64(self)
    }
}

extension UInt: ValueConvertible {
    public var sqlValue: Value {
        return .uint(self)
    }
}

extension UInt8: ValueConvertible {
    public var sqlValue: Value {
        return .uint8(self)
    }
}

extension UInt16: ValueConvertible {
    public var sqlValue: Value {
        return .uint16(self)
    }
}

extension UInt32: ValueConvertible {
    public var sqlValue: Value {
        return .uint32(self)
    }
}

extension UInt64: ValueConvertible {
    public var sqlValue: Value {
        return .uint64(self)
    }
}
