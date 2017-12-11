//
//  Insert.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

public protocol InsertQuery: SettableQuery, ChangeQuery {}

public struct ConstrainedInsertQuery<T: TableStorable>: InsertQuery, TableConstrainedQuery {
    public typealias Table = T

    public var setters: [String:QueryComponent] = [:]

    public var parameters: [Value] {
        return self.setters.values.flatMap({$0.arguments})
    }

    public var statement: String {
        let keys = setters.keys.joined(separator: ",")
        let values = setters.values.map({$0.sql}).joined(separator: ", ")
        return "INSERT INTO \(T.tableName) (\(keys)) VALUES (\(values))"
    }

    public var arguments: [Value] {
        return self.setters.flatMap({$0.value.arguments})
    }

    public func returning(_ selections: [Selectable<T>] = [.all]) -> InsertAndSelectQuery<T> {
        return InsertAndSelectQuery(setters: self.setters, selections: selections)
    }
}

public struct InsertAndSelectQuery<T: TableStorable>: InsertQuery, RowReturningQuery, TableConstrainedQuery {
    public typealias Table = T

    public var setters: [String:QueryComponent] = [:]
    public var selections: [SQLConvertible] = []

    public var parameters: [Value] {
        return self.setters.values.flatMap({$0.arguments})
    }

    public var statement: String {
        let keys = setters.keys.joined(separator: ",")
        let values = setters.values.map({$0.sql}).joined(separator: ", ")
        return "INSERT INTO \(T.tableName) (\(keys)) VALUES (\(values)) RETURNING \(selections.map({$0.sql}).joined(separator: ", "))"
    }

    public var arguments: [Value] {
        return self.setters.flatMap({$0.value.arguments})
    }
}

public struct RawInsertQuery: EmptyResultQuery, ChangeQuery {
    public let statement: String
    public let arguments: [Value] = []
}
