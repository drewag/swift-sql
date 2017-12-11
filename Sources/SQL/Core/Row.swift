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
    public init() {}

    open subscript(string: String) -> Data? {
        fatalError("Must override")
    }

    open var columns: [String] {
        fatalError("Must override")
    }
}

extension Row where Query: TableConstrainedQuery {
    public func get<R: RowRetrievable>(_ field: Query.Table.Fields) throws -> R {
        guard let value: R = try self.getIfExists(field) else {
            throw SQLError(
                message: "A value for '\(Query.Table.field(field).sql)' does not exist",
                moreInformation: "This result has the following columns: '\(self.columns.joined(separator: "', '"))'")
        }
        return value
    }

    public func getIfExists<R: RowRetrievable>(_ field: Query.Table.Fields) throws -> R? {
        for key in Query.Table.field(field).possibleKeys {
            if let value = self[key] {
                return try R(sqlResult: value)
            }
        }
        return nil
    }
}

extension Row {
    public func get<R: RowRetrievable>(column: String) throws -> R {
        guard let value: R = try self.getIfExists(column: column) else {
            throw SQLError(
                message: "A value for '\(column)' does not exist",
                moreInformation: "This result has the following columns: '\(self.columns.joined(separator: "', '"))'")
        }
        return value
    }

    public func getIfExists<R: RowRetrievable>(column: String) throws -> R? {
        if let value = self[column] {
            return try R(sqlResult: value)
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
        guard let value = Double(string) else {
            throw SQLError(message: "Invalid Double value", moreInformation: "Was '\(string)'")
        }
        self = value
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

extension QualifiedField {
    var possibleKeys: [String] {
        if let alias = self.alias {
            return [alias]
        }
        else if let table = self.table {
            return ["\(table).\(self.name)", self.name]
        }
        else {
            return [self.name]
        }
    }
}
