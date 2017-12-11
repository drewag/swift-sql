//
//  SelectQuery.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/10/17.
//

public struct SelectQuery<T: TableStorable>: RowReturningQuery, FilterableQuery, JoinableQuery, TableConstrainedQuery {
    public typealias Table = T

    var selections: [SQLConvertible] = []
    public var predicate: Predicate?
    var limit: Int?
    public var joins: [Join] = []

    init(selections: [SQLConvertible]) {
        self.selections = selections
    }

    public var statement: String {
        var sql = "SELECT \(selections.map({$0.sql}).joined(separator: ", ")) FROM \(T.tableName)"

        for join in self.joins {
            sql += " \(join.sql)"
        }

        if let predicate = predicate {
            sql += " WHERE \(predicate.sql)"
        }
        if let limit = self.limit {
            sql += "LIMIT \(limit)"
        }
        return sql
    }

    public var arguments: [Value] {
        return self.joins.flatMap({$0.arguments}) + (predicate?.arguments ?? [])
    }
}
