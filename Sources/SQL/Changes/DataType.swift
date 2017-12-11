//
//  DataType.swift
//  SwiftServePostgresPackageDescription
//
//  Created by Andrew J Wagner on 12/5/17.
//

public enum DataType: SQLConvertible {
    case string(length: Int?)
    case timestamp
    case timestampWithTimeZone
    case interval
    case ipAddress
    case date
    case bool
    case serial
    case integer
    case smallint
    case double
    case uuid

    public var sql: String {
        switch self {
        case .date:
            return "date"
        case .ipAddress:
            return "inet"
        case .timestamp:
            return "timestamp"
        case .timestampWithTimeZone:
            return "timestamp with time zone"
        case .string(let length):
            if let length = length {
                return "varchar(\(length))"
            }
            else {
                return "varchar"
            }
        case .bool:
            return "boolean"
        case .serial:
            return "SERIAL"
        case .integer:
            return "integer"
        case .smallint:
            return "smallint"
        case .double:
            return "double precision"
        case .interval:
            return "interval"
        case .uuid:
            return "uuid"
        }

    }
}
