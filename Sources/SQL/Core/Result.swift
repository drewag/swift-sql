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

    public init(dataProvider: ResultDataProvider) {
        self.dataProvider = dataProvider
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

extension Result where Query: CountReturningQuery {
    public func count(called: String = "count") throws -> Int {
        guard let row: Row<Query> = self.dataProvider.rows().next() else {
            return 0
        }
        return try row.get(column: called)
    }
}

open class RowSequence<Query: RowReturningQuery>: Sequence, IteratorProtocol {
    public init() {}

    open func next() -> Row<Query>? {
        fatalError("Must override")
    }
}

