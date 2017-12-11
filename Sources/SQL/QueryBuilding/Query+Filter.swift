//
//  Query+Filtering.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

public protocol FilterableQuery: AnyQuery {
    /// Intended for internal use
    ///
    /// Use 'filter' and 'filtered' methods instead
    var predicate: Predicate? { get set }
}

public extension FilterableQuery {
    public mutating func filter(_ value: Predicate)  {
        guard let existing = predicate else {
            predicate = value
            return
        }

        predicate = .and([existing, value])
    }

    public func filtered(_ value: Predicate) -> Self {
        var new = self
        new.filter(value)
        return new
    }
}
