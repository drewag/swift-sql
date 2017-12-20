//
//  Calculation.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/16/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public indirect enum Calculation: QueryComponent {
    case negate(Parameter)
    case add(lhs: Parameter, rhs: Parameter)
    case subtract(lhs: Parameter, rhs: Parameter)
    case multiply(lhs: Parameter, rhs: Parameter)
    case divide(lhs: Parameter, rhs: Parameter)

    public var sql: String {
        switch self {
        case .negate(let param):
            return "-(\(param.sql))"
        case let .add(lhs, rhs):
            return "(\(lhs.sql) + \(rhs.sql))"
        case let .subtract(lhs, rhs):
            return "(\(lhs.sql) - \(rhs.sql))"
        case let .multiply(lhs, rhs):
            return "(\(lhs.sql) * \(rhs.sql))"
        case let .divide(lhs, rhs):
            return "(\(lhs.sql) / \(rhs.sql))"
        }
    }

    public var arguments: [Value] {
        switch self {
        case .negate(let param):
            return param.arguments
        case let .add(lhs, rhs):
            return lhs.arguments + rhs.arguments
        case let .subtract(lhs, rhs):
            return lhs.arguments + rhs.arguments
        case let .multiply(lhs, rhs):
            return lhs.arguments + rhs.arguments
        case let .divide(lhs, rhs):
            return lhs.arguments + rhs.arguments
        }
    }
}

extension Calculation: ParameterConvertible {
    public var sqlParameter: Parameter {
        return .calculation(self)
    }
}

public prefix func - (parameter: ParameterConvertible) -> Calculation {
    return .negate(parameter.sqlParameter)
}

public func + (lhs: ParameterConvertible, rhs: ParameterConvertible) -> Calculation {
    return .add(lhs: lhs.sqlParameter, rhs: rhs.sqlParameter)
}

public func - (lhs: ParameterConvertible, rhs: ParameterConvertible) -> Calculation {
    return .subtract(lhs: lhs.sqlParameter, rhs: rhs.sqlParameter)
}

public func / (lhs: ParameterConvertible, rhs: ParameterConvertible) -> Calculation {
    return .divide(lhs: lhs.sqlParameter, rhs: rhs.sqlParameter)
}

public func * (lhs: ParameterConvertible, rhs: ParameterConvertible) -> Calculation {
    return .multiply(lhs: lhs.sqlParameter, rhs: rhs.sqlParameter)
}
