//
//  Update.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

public protocol UpdateQuery: ChangeQuery, FilterableQuery, SettableQuery {}

extension UpdateQuery {
    public var statement: String {
        let setters = self.setters.map({ "\($0) = \($1.sql)"}).joined(separator: ", ")
        var sql = "UPDATE \(self.tableName) SET \(setters)"
        if let predicate = predicate {
            sql += " WHERE \(predicate.sql)"
        }
        return sql
    }

    public var arguments: [Value] {
        return self.setters.flatMap({$0.value.arguments})
            + (self.predicate?.arguments ?? [])
    }
}

public struct UpdateTableQuery<T: TableStorable>: UpdateQuery, TableConstrainedQuery {
    public typealias Table = T

    public var predicate: Predicate?
    public var setters: [String:QueryComponent] = [:]

    public init() {}
}

public struct UpdateArbitraryQuery: UpdateQuery {
    public let tableName: String
    public var predicate: Predicate?
    public var setters: [String:QueryComponent] = [:]

    public init(_ tableName: String) {
        self.tableName = tableName
    }
}

public struct RawUpdateQuery: ChangeQuery {
    public let statement: String
    public let arguments: [Value] = []
}

