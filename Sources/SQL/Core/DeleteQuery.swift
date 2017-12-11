//
//  Delete.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

public struct DeleteQuery: TableQuery, EmptyResultQuery, ChangeQuery, FilterableQuery {
    public let tableName: String
    public var predicate: Predicate?

    public init(from tableName: String) {
        self.tableName = tableName
    }

    public var statement: String {
        var sql = "DELETE FROM \(self.tableName)"
        if let predicate = predicate {
            sql += " WHERE \(predicate.sql)"
        }
        return sql
    }

    public var arguments: [Value] {
        return self.predicate?.arguments ?? []
    }
}

public struct RawDeleteQuery: EmptyResultQuery, ChangeQuery {
    public let statement: String
    public let arguments: [Value] = []
}
