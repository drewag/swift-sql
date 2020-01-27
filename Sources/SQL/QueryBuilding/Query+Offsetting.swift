//
//  Query+Offsetting.swift
//  SQL
//
//  Created by Andrew J Wagner on 1/24/20.
//

extension SelectQuery {
    public func offset(by offset: Int) -> SelectQuery<T> {
        var new = self
        new.offset = offset
        return new
    }
}
