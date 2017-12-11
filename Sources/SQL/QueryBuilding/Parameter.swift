//
//  Parameter.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/5/17.
//

import Foundation

public enum Parameter: QueryComponent, ParameterConvertible {
    case field(QualifiedField)
    case value(Value?)
    case values([Value?])
    case function(Function)
//    case query(Select)
    case null

    public var sql: String {
        switch self {
        case .field(let field):
            return field.sql
        case .value(let value):
            return value?.sql ?? "NULL"
        case .values(let values):
            return "(" + values.map({$0?.sql ?? "NULL"}).joined(separator: ",") + ")"
        case .function(let function):
            return function.sql
//        case .query(let query):
//            return "(\(query.sql))"
        case .null:
            return "NULL"
        }
    }

    public var arguments: [Value] {
        switch self {
        case .field:
            return []
        case .value(let value):
            guard let value = value else {
                return []
            }
            return [value]
        case .values(let values):
            return values.flatMap({$0})
        case .function(let function):
            return function.arguments
        case .null:
            return []
        }
    }

    public var sqlParameter: Parameter {
        return self
    }
}

public protocol ParameterConvertible {
    var sqlParameter: Parameter {get}
}

extension Date: ParameterConvertible {
    public var sqlParameter: Parameter {
        return .function(.toTimestamp(date: self))
    }
}

public indirect enum Selectable<T: TableStorable>: QueryComponent {
    case my(T.Fields)
    case other(QualifiedField)
    case function(Function)
    case all

    public static func sum(_ sum: Selectable<T>) -> Selectable<T> {
        return .function(.sum(sum))
    }

    public var sql: String {
        switch self {
        case let .my(field):
            return T.field(field).sql
        case let .other(field):
            return field.sql
        case let .function(function):
            return function.sql
        case .all:
            return "*"
        }
    }

    public var arguments: [Value] {
        switch self {
        case .my, .other, .all:
            return []
        case let .function(function):
            return function.arguments
        }
    }
}
