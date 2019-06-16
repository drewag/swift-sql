//
//  DataType.swift
//  SwiftServePostgresPackageDescription
//
//  Created by Andrew J Wagner on 12/5/17.
//

import Foundation

public enum DataType: SQLConvertible {
    case string(length: Int?)
    case timestamp
    case timestampWithTimeZone
    case time
    case interval
    case ipAddress
    case date
    case bool
    case serial
    case integer
    case smallint
    case double
    case float
    case uuid
    case data
    case json
    case point

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
        case .time:
            return "time"
        case .string(let length):
            if let length = length {
                return "varchar(\(length))"
            }
            else {
                return "varchar"
            }
        case .json:
            return "varchar"
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
        case .float:
            return "float"
        case .interval:
            return "interval"
        case .uuid:
            return "uuid"
        case .data:
            return "data"
        case .point:
            return "point"
        }
    }
}
