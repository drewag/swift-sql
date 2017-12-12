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
        guard let row: Row<Query> = self.dataProvider.rows().first else {
            return 0
        }
        return try row.get(column: called)
    }
}

open class RowSequence<Query: RowReturningQuery>: Collection {
    public init() {}

    var currentRow: Int = -1

    open var count: Int {
        fatalError("Must override")
    }

    open subscript(i: Int) -> Row<Query> {
        fatalError("Must override")
    }

    public func next() -> Row<Query>? {
        guard self.currentRow + 1 < self.count else {
            return nil
        }
        self.currentRow += 1
        return self[self.currentRow]
    }

    public let startIndex: Int = 0

    public var endIndex: Int {
        return self.count
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }
}

