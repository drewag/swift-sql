//
//  Query+Grouping.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/13/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public protocol GroupingQuery: TableConstrainedQuery {
    var groupBy: [QueryComponent] {get set}
    var having: Predicate? {get set}
}

extension GroupingQuery {
    public func grouped(by field: Table.Fields, having: Predicate? = nil) -> Self {
        var new = self
        new.groupBy = [Table.field(field)]
        new.having = having
        return new
    }

    public func grouped(byOther fields: [ParameterConvertible], having: Predicate? = nil) -> Self {
        var new = self
        new.groupBy = fields.map({$0.sqlParameter})
        new.having = having
        return new
    }
}

