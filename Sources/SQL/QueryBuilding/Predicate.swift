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
}

// MARK: Is Null

extension ParameterConvertible {
    public func isNull() -> Predicate {
        return .expression(left: self.sqlParameter, operator: .equal, right: .null)
    }

    public func isNotNulll() -> Predicate {
        return .not(isNull())
    }
}

// MARK: Compound predicate

public func && (lhs: Predicate, rhs: Predicate) -> Predicate {
    return .and([lhs, rhs])
}

public func || (lhs: Predicate, rhs: Predicate) -> Predicate {
    return .or([lhs, rhs])
}

