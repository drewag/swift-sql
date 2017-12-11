//
//  Operator.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/5/17.
//

public enum Operator: SQLConvertible {
    case equal
    case notEqual

    case greaterThan
    case greaterThanOrEqual

    case lessThan
    case lessThanOrEqual
    case contains
    case containedIn

    public var sql: String {
        switch self {
        case .equal:
            return "="
        case .notEqual:
            return "!="
        case .greaterThan:
            return ">"
        case .greaterThanOrEqual:
            return ">="
        case .lessThan:
            return "<"
        case .lessThanOrEqual:
            return "<="
        case .contains:
            return "CONTAINS"
        case .containedIn:
            return "IN"
        }
    }
}
