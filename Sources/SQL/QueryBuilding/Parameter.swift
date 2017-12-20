//
//  Parameter.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/5/17.
//

import Foundation

public indirect enum Parameter: QueryComponent, ParameterConvertible {
    case field(QualifiedField)
    case value(Value?)
    case values([Value?])
    case function(Function)
    case calculation(Calculation)
    case alias(String, Parameter)
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
        case .calculation(let calculation):
            return calculation.sql
        case .alias(let alias, let param):
            return "\(param.sql) AS \(alias)"
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
        case .calculation(let calculation):
            return calculation.arguments
        case .alias(_, let param):
            return param.arguments
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

public extension Parameter {
    func aliased(_ alias: String) -> Parameter {
        return .alias(alias, self)
    }
}

public extension ParameterConvertible {
    func aliased(_ alias: String) -> Parameter {
        return self.sqlParameter.aliased(alias)
    }
}

extension Date: ParameterConvertible {
    public var sqlParameter: Parameter {
        return .function(.toTimestamp(date: self))
    }
}
