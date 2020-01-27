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
    var offset: Int?
    public var joins: [Join] = []
    public var orderBy: [QueryComponent] = []
    public var orderDirection: OrderDirection = .ascending
    public var groupBy: [QueryComponent] = []
    public var having: Predicate? = nil
    public var isSelectingAll: Bool
    public var distinctOn: QueryComponent?

    init(selections: [QueryComponent], distinctOn: QueryComponent?, isSelectingAll: Bool) {
        self.selections = selections
        self.isSelectingAll = isSelectingAll
        self.distinctOn = distinctOn
    }

    public var statement: String {
        var sql = "SELECT"

        if let distinctOn = self.distinctOn {
            sql += " DISTINCT ON (\(distinctOn.sql))"
        }

        sql += " \(selections.map({$0.sql}).joined(separator: ", ")) FROM \(T.tableName)"

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

        if let offset = self.offset, offset != 0 {
            sql += " OFFSET \(offset)"
        }

        return sql
    }

    public var arguments: [Value] {
        return (distinctOn?.arguments ?? [])
            + self.selections.flatMap({$0.arguments})
            + self.joins.flatMap({$0.arguments})
            + (predicate?.arguments ?? [])
            + groupBy.flatMap({$0.arguments})
            + (having?.arguments ?? [])
            + orderBy.flatMap({$0.arguments})
    }

    public mutating func didJoin<T: TableStorable>(to storableType: T.Type) {
        if self.isSelectingAll {
            for field in storableType.Fields.allCases {
                self.selections.append(T.field(field).aliased("\(T.tableName)__\(field.stringValue)"))
            }
        }
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

public struct RawSelectQuery: RowReturningQuery {
    public var statement: String

    public var arguments: [Value]

    public init(sql: String, arguments: [Value] = []) {
        self.statement = sql
        self.arguments = arguments
    }
}
