//
//  Predicate.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//


public indirect enum Predicate: QueryComponent {
    case expression(left: Parameter, operator: Operator, right: Parameter)
    case and([Predicate])
    case or([Predicate])
    case not(Predicate)
    case isNull(Parameter)
    case isNotNull(Parameter)

    public var sql: String {
        switch self {
        case .expression(let left, let op, let right):
            return "\(left.sql) \(op.sql) \(right.sql)"
        case .and(let predicates):
            return "(" + predicates.map({$0.sql}).joined(separator: " AND ") + ")"
        case .or(let predicates):
            return "(" + predicates.map({$0.sql}).joined(separator: " OR ")  + ")"
        case .not(let predicate):
            return "NOT \(predicate.sql)"
        case .isNull(let param):
            return "\(param.sql) IS NULL"
        case .isNotNull(let param):
            return "\(param.sql) IS NOT NULL"
        }
    }

    public var arguments: [Value] {
        switch self {
        case .expression(let left, _, let right):
            return left.arguments + right.arguments
        case .and(let predicates):
            return predicates.flatMap({$0.arguments})
        case .or(let predicates):
            return predicates.flatMap({$0.arguments})
        case .not(let predicate):
            return predicate.arguments
        case .isNull(let param):
            return param.arguments
        case .isNotNull(let param):
            return param.arguments
        }
    }
}

public prefix func ! (predicate: Predicate) -> Predicate {
    return .not(predicate)
}

public func == (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .value(.null), operator: .equal, right: rhs?.sqlParameter ?? .value(.null))
}

public func != (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .value(.null), operator: .notEqual, right: rhs?.sqlParameter ?? .value(.null))
}

public func > (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .value(.null), operator: .greaterThan, right: rhs?.sqlParameter ?? .value(.null))
}

public func < (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .value(.null), operator: .lessThan, right: rhs?.sqlParameter ?? .value(.null))
}

public func >= (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .value(.null), operator: .greaterThanOrEqual, right: rhs?.sqlParameter ?? .value(.null))
}

public func <= (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .value(.null), operator: .lessThanOrEqual, right: rhs?.sqlParameter ?? .value(.null))
}

infix operator |---|
public func |---| (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .value(.null), operator: .earthDistance, right: rhs?.sqlParameter ?? .value(.null))
}

// MARK: Contains

extension ParameterConvertible {
    public func contains(_ values: [ValueConvertible?]) -> Predicate {
        return contains(values.map { $0?.sqlValue })
    }

    public func contains(_ values: ValueConvertible?...) -> Predicate {
        return contains(values)
    }

    public func contains(_ values: [Value?]) -> Predicate {
        return .expression(left: self.sqlParameter, operator: .contains, right: .values(values))
    }

    public func contains(_ values: Value?...) -> Predicate {
        return contains(values)
    }

    public func containedIn(_ values: [ValueConvertible?]) -> Predicate {
        return containedIn(values.map { $0?.sqlValue })
    }

    public func containedIn(_ values: ValueConvertible?...) -> Predicate {
        return containedIn(values)
    }

    public func containedIn(_ values: [Value?]) -> Predicate {
        return .expression(left: self.sqlParameter, operator: .containedIn, right: .values(values))
    }

    public func containedIn(_ values: Value?...) -> Predicate {
        return containedIn(values)
    }

    public func like(_ rhs: ParameterConvertible) -> Predicate {
        return .expression(left: self.sqlParameter, operator: .like, right: rhs.sqlParameter)
    }

    public func match(_ rhs: ParameterConvertible) -> Predicate {
        return .expression(left: self.sqlParameter, operator: .match, right: rhs.sqlParameter)
    }
}

// MARK: Is Null

extension ParameterConvertible {
    public var isNull: Predicate {
        return .isNull(self.sqlParameter)
    }

    public var isNotNull: Predicate {
        return .isNotNull(self.sqlParameter)
    }
}

// MARK: Compound predicate

public func && (lhs: Predicate, rhs: Predicate) -> Predicate {
    return .and([lhs, rhs])
}

public func || (lhs: Predicate, rhs: Predicate) -> Predicate {
    return .or([lhs, rhs])
}

