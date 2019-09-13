//
//  File.swift
//  
//
//  Created by Andrew J Wagner on 9/12/19.
//

import Foundation
import Swiftlier

enum EncodedSQLValue {
    case none
    case leaf(Value)
    case dict([String:EncodedSQLValue])
    case array([EncodedSQLValue])
}

extension EncodedSQLValue {
    var value: ValueConvertible {
        switch self {
        case .none:
            return Value.null
        case .dict(let dict):
            let json = JSON(object: dict.jsonObject)
            guard let data = try? json.data()
                , let string = String(data: data, encoding: .utf8)
                else
            {
                return "INVALID JSON"
            }
            return string
        case .array(let array):
            let json = JSON(object: array.jsonObject)
            guard let data = try? json.data()
                , let string = String(data: data, encoding: .utf8)
                else
            {
                return "INVALID JSON"
            }
            return string
        case .leaf(let value):
            switch value {
            case .bool(let bool):
                return bool
            case .data(let data):
                return data
            case .double(let double):
                return double
            case .float(let float):
                return float
            case .int(let int):
                return int
            case .int16(let int):
                return int
            case .int32(let int):
                return int
            case .int64(let int):
                return int
            case .string(let value):
                return value
            case .int8(let value):
                return value
            case .uint(let value):
                return value
            case .uint8(let value):
                return value
            case .uint16(let value):
                return value
            case .uint32(let value):
                return value
            case .uint64(let value):
                return value
            case .null:
                return Value.null
            case .point(let x, let y):
                return Point(x: x, y: y)
            case .time(let hour, let minute, let second):
                return Time(hour: hour, minute: minute, second: second)
            }
        }
    }

    var jsonObject: Any {
        switch self {
        case .array(let array):
            return array.jsonObject
        case .dict(let dict):
            return dict.jsonObject
        case .none:
            return NSNull()
        case .leaf(let value):
            switch value {
            case .bool(let bool):
                return bool
            case .data(let data):
                return data.base64
            case .double(let double):
                return double
            case .float(let float):
                return float
            case .int(let int):
                return int
            case .string(let value):
                return value
            case .int8(let value):
                return Int(value)
            case .int16(let value):
                return Int(value)
            case .int32(let value):
                return Int(value)
            case .int64(let value):
                return Int(value)
            case .uint(let value):
                return Int(value)
            case .uint8(let value):
                return Int(value)
            case .uint16(let value):
                return Int(value)
            case .uint32(let value):
                return Int(value)
            case .uint64(let value):
                return Int(value)
            case .null:
                return NSNull()
            case .point(let x, let y):
                return ["x": x, "y": y]
            case .time(let hour, let minute, let second):
                return "\(hour):\(minute):\(second)"
            }
        }
    }
}

extension Array where Element == EncodedSQLValue {
    var jsonObject: [Any] {
        return self.map({ $0.jsonObject })
    }
}

extension Dictionary where Key == String, Value == EncodedSQLValue {
    var jsonObject: [String:Any] {
        return self.mapValues({ $0.jsonObject })
    }
}
