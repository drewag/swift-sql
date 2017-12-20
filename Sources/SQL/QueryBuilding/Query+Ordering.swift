//
//  Query+Ordering.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/13/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public enum OrderDirection {
    case ascending
    case descending
}

public protocol OrderableQuery: TableConstrainedQuery {
    var orderBy: [QueryComponent] {get set}
    var orderDirection: OrderDirection {get set}
}

extension OrderableQuery {
    public func ordered(by field: Table.Fields, _ direction: OrderDirection = .ascending) -> Self {
        return self.ordered(by: Table.field(field), direction)
    }

    public func ordered(by fields: [Table.Fields], _ direction: OrderDirection = .ascending) -> Self {
        return self.ordered(by: fields.map({Table.field($0)}), direction)
    }

    public func ordered(by field: QualifiedField, _ direction: OrderDirection = .ascending) -> Self {
        var new = self
        new.orderBy = [field]
        new.orderDirection = direction
        return new
    }

    public func ordered(by fields: [QualifiedField], _ direction: OrderDirection = .ascending) -> Self {
        var new = self
        new.orderBy = fields.map({$0})
        new.orderDirection = direction
        return new
    }
}
