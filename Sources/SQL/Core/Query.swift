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

struct RawEmptyQuery: EmptyResultQuery {
    public let statement: String
    public let arguments: [Value] = []

    public init(sql: String) {
        self.statement = sql
    }
}


