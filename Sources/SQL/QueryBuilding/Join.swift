//
//  Join.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/8/17.
//

public struct Join: QueryComponent {
    enum Kind: String {
        case inner = "INNER JOIN"
        case leftOuter = "LEFT OUTER JOIN"
        case rightOuter = "RIGHT OUTER JOIN"
        case fullOuter = "FULL OUTER JOIN"
    }

    let tableName: String
    let kind: Kind
    let on: Predicate

    init(tableName: String, kind: Kind, on: Predicate) {
        self.tableName = tableName
        self.kind = kind
        self.on = on
    }

    public var arguments: [Value] {
        return self.on.arguments
    }

    public var sql: String {
        return "\(self.kind.rawValue) \(self.tableName) ON \(self.on.sql)"
    }
}
