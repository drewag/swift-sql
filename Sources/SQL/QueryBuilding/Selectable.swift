//
//  Selectable.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/16/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public protocol Selectable: QueryComponent {
}

public struct All: Selectable {
    var table: String?

    init(table: String? = nil) {
        self.table = table
    }

    public var sql: String {
        if let table = self.table {
            return "\(table).*"
        }
        return "*"
    }

    public var arguments: [Value] {
        return []
    }
    public init() {}
}

extension QualifiedField: Selectable {}
extension Function: Selectable {}
extension Parameter: Selectable {}
