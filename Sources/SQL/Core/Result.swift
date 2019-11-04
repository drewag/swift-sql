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

public protocol AnyResult {
    associatedtype Query
    var dataProvider: ResultDataProvider {get}
}

public struct Result<Query: AnyQuery>: AnyResult {
    public let dataProvider: ResultDataProvider
    fileprivate var query: Query

    public init(dataProvider: ResultDataProvider, query: Query) {
        self.dataProvider = dataProvider
        self.query = query
    }
}

public struct RowsResult<Query: RowReturningQuery>: AnyResult {
    public let dataProvider: ResultDataProvider
    fileprivate var query: Query
    public let rows: RowSequence<Query>

    public init(dataProvider: ResultDataProvider, query: Query) {
        self.dataProvider = dataProvider
        self.query = query
        self.rows = dataProvider.rows()
    }
}

extension AnyResult where Query: ChangeQuery {
    public var countAffected: Int {
        return self.dataProvider.countAffected
    }
}

extension AnyResult where Query: ScalarReturningQuery {
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

