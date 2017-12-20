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
    public var sql: String {
        return "*"
    }
    public var arguments: [Value] {
        return []
    }
}

extension QualifiedField: Selectable {}
extension Function: Selectable {}
extension Parameter: Selectable {}
