//
//  Query+Limiting.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

extension SelectQuery {
    public func limited(to limit: Int) -> SelectQuery<T> {
        var new = self
        new.limit = limit
        return self
    }
}
