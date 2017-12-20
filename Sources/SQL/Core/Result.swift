//
//  Result.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/10/17.
//


public protocol ResultDataProvider {
    var countAffected: Int {get}
    func rows<Query: RowReturningQuery>() -> RowSequence<Query>
}

public struct Result<Query: AnyQuery> {
    fileprivate var dataProvider: ResultDataProvider
    fileprivate var query: Query

    public init(dataProvider: ResultDataProvider, query: Query) {
        self.dataProvider = dataProvider
        self.query = query
    }
}

extension Result where Query: RowReturningQuery {
    public var rows: RowSequence<Query> {
        return self.dataProvider.rows()
    }
}

extension Result where Query: ChangeQuery {
    public var countAffected: Int {
        return self.dataProvider.countAffected
    }
}

extension Result where Query: ScalarReturningQuery {
    public func scalarIfExists() throws -> Int? {
        guard let row: Row<Query> = self.dataProvider.rows().next() else {
            return nil
        }
        return try row.getIfExists(column: "scalar")
    }

    public func scalar() throws -> Int {
        guard let row: Row<Query> = self.dataProvider.rows().next() else {
            throw SQLError(message: "Failed to calculate scalar because no rows were returned")
        }
        return try row.get(column: "scalar")
    }
}

open class RowSequence<Query: RowReturningQuery>: Sequence, IteratorProtocol {
    public init() {}

    open func next() -> Row<Query>? {
        fatalError("Must override")
    }
}

