//
//  SelectQuery.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/10/17.
//

public struct SelectQuery<T: TableStorable>: RowReturningQuery, FilterableQuery, JoinableQuery, OrderableQuery, GroupingQuery {
    public typealias Table = T

    var selections: [QueryComponent] = []
    public var predicate: Predicate?
    var limit: Int?
    public var joins: [Join] = []
    public var orderBy: [QueryComponent] = []
    public var orderDirection: OrderDirection = .ascending
    public var groupBy: [QueryComponent] = []
    public var having: Predicate? = nil

    init(selections: [QueryComponent]) {
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

        if !groupBy.isEmpty {
            sql += " GROUP BY \(groupBy.map({$0.sql}).joined(separator: ", "))"

            if let having = having {
                sql += " HAVING \(having.sql)"
            }
        }

        if !orderBy.isEmpty {
            sql += " ORDER BY \(orderBy.map({$0.sql}).joined(separator: ", "))"
            switch orderDirection {
            case .ascending:
                break
            case .descending:
                sql += " DESC"
            }
        }

        if let limit = self.limit {
            sql += " LIMIT \(limit)"
        }
        return sql
    }

    public var arguments: [Value] {
        return self.joins.flatMap({$0.arguments})
            + (predicate?.arguments ?? [])
            + groupBy.flatMap({$0.arguments})
            + (having?.arguments ?? [])
            + orderBy.flatMap({$0.arguments})
    }
}

public struct SelectScalarQuery<T: TableStorable>: ScalarReturningQuery, FilterableQuery, OrderableQuery, GroupingQuery {
    public typealias Table = T

    var selection: SQLConvertible
    public var predicate: Predicate?
    public var orderBy: [QueryComponent] = []
    public var orderDirection: OrderDirection = .ascending
    public var groupBy: [QueryComponent] = []
    public var having: Predicate? = nil

    init(selection: SQLConvertible) {
        self.selection = selection
    }

    public var statement: String {
        var sql = "SELECT \(selection.sql) AS scalar FROM \(T.tableName)"

        if let predicate = predicate {
            sql += " WHERE \(predicate.sql)"
        }

        if !groupBy.isEmpty {
            sql += " GROUP BY \(groupBy.map({$0.sql}).joined(separator: ", "))"

            if let having = having {
                sql += " HAVING \(having.sql)"
            }
        }

        if !orderBy.isEmpty {
            sql += " ORDER BY \(orderBy.map({$0.sql}).joined(separator: ", "))"
            switch orderDirection {
            case .ascending:
                break
            case .descending:
                sql += " DESC"
            }
        }

        return sql
    }

    public var arguments: [Value] {
        return (predicate?.arguments ?? [])
            + groupBy.flatMap({$0.arguments})
            + (having?.arguments ?? [])
            + orderBy.flatMap({$0.arguments})
    }
}
