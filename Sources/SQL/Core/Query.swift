//
//  Query.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/10/17.
//

public protocol QueryComponent: SQLConvertible {
    var arguments: [Value] {get}
}

public protocol SQLConvertible {
    var sql: String {get}
}

public protocol AnyQuery {
    var statement: String {get}
    var arguments: [Value] {get}
}

public protocol RowReturningQuery: AnyQuery {}
public protocol ScalarReturningQuery: RowReturningQuery {}
public protocol ChangeQuery: AnyQuery {}
public protocol EmptyResultQuery: AnyQuery {}
public protocol TableQuery: AnyQuery {
    var tableName: String {get}
}
public protocol TableConstrainedQuery: AnyQuery {
    associatedtype Table: TableStorable
}

extension TableConstrainedQuery {
    public var tableName: String {
        return Table.tableName
    }
}

public struct RawEmptyQuery: EmptyResultQuery {
    public let statement: String
    public let arguments: [Value]

    public init(sql: String, arguments: [Value] = []) {
        self.statement = sql
        self.arguments = arguments
    }
}

extension QueryComponent {
    func rendered() throws -> String {
        var output: String = ""
        var varCount = 0
        let arguments = self.arguments
        let sql = self.sql
        for (index, component) in sql.components(separatedBy: "%@").enumerated() {
            if !output.isEmpty || index > 0 {
                guard varCount < arguments.count else {
                    throw SQLError(message: "rendering SQL because it has the incorrect number arguments")
                }
                let value = arguments[varCount]
                switch value {
                case .null:
                    output += "NULL"
                case .bool(let bool):
                    output += (bool ? "true" : "false")
                case .string(let string):
                    output += "'\(string)'"
                case .data:
                    throw SQLError(message: "cannot render SQL with data value")
                case .float(let value):
                    output += "\(value)"
                case .double(let value):
                    output += "\(value)"
                case .int(let value):
                    output += "\(value)"
                case .int8(let value):
                    output += "\(value)"
                case .int16(let value):
                    output += "\(value)"
                case .int32(let value):
                    output += "\(value)"
                case .int64(let value):
                    output += "\(value)"
                case .uint(let value):
                    output += "\(value)"
                case .uint8(let value):
                    output += "\(value)"
                case .uint16(let value):
                    output += "\(value)"
                case .uint32(let value):
                    output += "\(value)"
                case .uint64(let value):
                    output += "\(value)"
                case .point(let x, let y):
                    output += "\(x),\(y)"
                case let .time(hour, minute, second):
                    output += "\(hour):\(minute):\(second)"
                }
                varCount += 1
            }
            output += component
        }
        return output
    }
}


