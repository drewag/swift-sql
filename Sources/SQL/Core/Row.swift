//
//  Row.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/5/17.
//

import Foundation

public protocol RowRetrievable {
    init(sqlResult: Data) throws
}

open class Row<Query: RowReturningQuery> {
    public init() {
    }

    open func data(forColumnNamed name: String) throws -> Data? {
        fatalError("Must override")
    }

    open var columns: [String] {
        fatalError("Must override")
    }
}

extension Row where Query: TableConstrainedQuery {
    public func get<R: RowRetrievable>(_ field: Query.Table.Fields) throws -> R {
        return try self.get(Query.Table.field(field))
    }

    public func getIfExists<R: RowRetrievable>(_ field: Query.Table.Fields) throws -> R? {
        return try self.getIfExists(Query.Table.field(field))
    }
}

extension Row {
    public func get<R: RowRetrievable>(_ field: QualifiedField) throws -> R {
        guard let value: R = try self.getIfExists(field) else {
            throw SQLError(
                message: "A value for '\(field.sql)' does not exist",
                moreInformation: "This result has the following columns: '\(self.columns.joined(separator: "', '"))'"
            )
        }
        return value
    }

    public func getIfExists<R: RowRetrievable>(_ field: QualifiedField) throws -> R? {
        for key in field.possibleKeys {
            if let value = try self.data(forColumnNamed: key) {
                return try R(sqlResult: value)
            }
        }
        return nil
    }

    public func get<R: RowRetrievable>(column: String) throws -> R {
        return try self.get(column: [column])
    }

    public func get<R: RowRetrievable>(column possibleNames: [String]) throws -> R {
        guard let value: R = try self.getIfExists(column: possibleNames) else {
            throw SQLError(
                message: "A value for '\(possibleNames)' does not exist",
                moreInformation: "This result has the following columns: '\(self.columns.joined(separator: "', '"))'")
        }
        return value
    }

    public func getIfExists<R: RowRetrievable>(column: String) throws -> R? {
        return try self.getIfExists(column: [column])
    }

    public func getIfExists<R: RowRetrievable>(column possibleNames: [String]) throws -> R? {
        for column in possibleNames {
            if let value = try self.data(forColumnNamed: column) {
                return try R(sqlResult: value)
            }
        }
        let columnDict = self.columns.reduce(into: [String:String]()) { result, name in
            let components = name.components(separatedBy: "__")
            guard components.count >= 2, let last = components.last else {
                return
            }
            result[last] = name
        }
        for name in possibleNames {
            if let originalName = columnDict[name]
                , let value = try self.data(forColumnNamed: originalName)
            {
                return try R(sqlResult: value)
            }
        }
        return nil
    }
}

extension String: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid string value", moreInformation: nil)
        }
        self = string
    }
}


extension Int: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid Int value", moreInformation: "Not a string")
        }
        guard let value = Int(string) else {
            throw SQLError(message: "Invalid Int value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension Int8: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid Int8 value", moreInformation: "Not a string")
        }
        guard let value = Int8(string) else {
            throw SQLError(message: "Invalid Int8 value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension Int16: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid Int16 value", moreInformation: "Not a string")
        }
        guard let value = Int16(string) else {
            throw SQLError(message: "Invalid Int16 value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension Int32: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid Int32 value", moreInformation: "Not a string")
        }
        guard let value = Int32(string) else {
            throw SQLError(message: "Invalid Int32 value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension Int64: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid Int64 value", moreInformation: "Not a string")
        }
        guard let value = Int64(string) else {
            throw SQLError(message: "Invalid Int64 value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension UInt: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid UInt value", moreInformation: "Not a string")
        }
        guard let value = UInt(string) else {
            throw SQLError(message: "Invalid UInt value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension UInt8: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid UInt8 value", moreInformation: "Not a string")
        }
        guard let value = UInt8(string) else {
            throw SQLError(message: "Invalid UInt8 value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension UInt16: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid UInt16 value", moreInformation: "Not a string")
        }
        guard let value = UInt16(string) else {
            throw SQLError(message: "Invalid UInt16 value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension UInt32: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid UInt32 value", moreInformation: "Not a string")
        }
        guard let value = UInt32(string) else {
            throw SQLError(message: "Invalid UInt32 value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension UInt64: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid UInt64 value", moreInformation: "Not a string")
        }
        guard let value = UInt64(string) else {
            throw SQLError(message: "Invalid UInt64 value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension Float: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid Float value", moreInformation: "Not a string")
        }
        guard let value = Float(string) else {
            throw SQLError(message: "Invalid Float value", moreInformation: "Was '\(string)'")
        }
        self = value
    }
}

extension Double: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid Double value", moreInformation: "Not a string")
        }
        if let value = Double(string) {
            self = value
            return
        }

        let components = string.components(separatedBy: ":")
        if components.count == 3 {
            // Potential Time Interval
            // [DD ]HH:MM:SS
            let days: Double?
            let hours: Double?
            let spaceComponents = components[0].components(separatedBy: " ")
            if spaceComponents.count == 2 {
                // DD HH
                days = Double(spaceComponents[0])
                hours = Double(spaceComponents[1])
            }
            else {
                // HH
                days = 0
                hours = Double(components[0])
            }
            let minutes = Double(components[1])
            let seconds = Double(components[2])

            if let d = days, let h = hours, let m = minutes, let s = seconds {
                self = s + m * 60 + h * 60 * 60 + d * 60 * 60 * 24
                return
            }
        }
        throw SQLError(message: "Invalid Double value '\(string)'", moreInformation: "Was '\(string)'")
    }
}

extension Bool: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid Bool value", moreInformation: "Not a string")
        }
        let lowercased = string.lowercased()
        self = lowercased == "true"
            || lowercased == "t"
            || lowercased == "y"
            || lowercased == "yes"
            || lowercased == "on"
            || lowercased == "1"
    }
}

extension Date: RowRetrievable {
    public init(sqlResult: Data) throws {
        guard let string = String(data: sqlResult, encoding: .utf8) else {
            throw SQLError(message: "Invalid Date value", moreInformation: "Not a string")
        }
        guard let date = string.iso8601DateTime else {
            throw SQLError(message: "Invalid Date value", moreInformation: "Not a valid iso 8601 date time")
        }
        self = date
    }
}

extension Data: RowRetrievable {
    public init(sqlResult: Data) throws {
        self = sqlResult
    }
}

extension QualifiedField {
    var possibleKeys: [String] {
        if let alias = self.alias {
            return [alias]
        }
        else if let table = self.table {
            return ["\(table)__\(self.name)","\(table).\(self.name)", self.name]
        }
        else {
            return [self.name]
        }
    }
}
