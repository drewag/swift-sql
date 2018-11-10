//
//  Query+Joining.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/8/17.
//

public protocol JoinableQuery: AnyQuery {
    var joins: [Join] {get set}

    mutating func didJoin<T: TableStorable>(to storableType: T.Type)
}

extension JoinableQuery {
    public func joined<T: TableStorable>(to storableType: T.Type, on predicate: Predicate) -> Self {
        var new = self
        new.joins.append(Join(tableName: T.tableName, kind: .inner, on: predicate))
        new.didJoin(to: storableType)
        return new
    }

    public func innerJoined<T: TableStorable>(to storableType: T.Type, on predicate: Predicate) -> Self {
        return self.joined(to: storableType, on: predicate)
    }

    public func crossJoined<T: TableStorable>(to storableType: T.Type, on predicate: Predicate) -> Self {
        var new = self
        new.joins.append(Join(tableName: T.tableName, kind: .cross, on: predicate))
        new.didJoin(to: storableType)
        return new
    }

    public func leftOuterJoined<T: TableStorable>(to storableType: T.Type, on predicate: Predicate) -> Self {
        var new = self
        new.joins.append(Join(tableName: T.tableName, kind: .leftOuter, on: predicate))
        new.didJoin(to: storableType)
        return new
    }

    public func rightOuterJoined<T: TableStorable>(to storableType: T.Type, on predicate: Predicate) -> Self {
        var new = self
        new.joins.append(Join(tableName: T.tableName, kind: .rightOuter, on: predicate))
        new.didJoin(to: storableType)
        return new
    }

    public func fullOuterJoined<T: TableStorable>(to storableType: T.Type, on predicate: Predicate) -> Self {
        var new = self
        new.joins.append(Join(tableName: T.tableName, kind: .fullOuter, on: predicate))
        new.didJoin(to: storableType)
        return new
    }
}
