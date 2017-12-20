//
//  Field.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/5/17.
//

public protocol Field: CodingKey {
    var sqlFieldSpec: FieldSpec? {get}
}

public struct QualifiedField: QueryComponent, Hashable {
    public let name: String
    public let table: String?
    public let alias: String?

    public init(name: String, table: String? = nil, alias: String? = nil) {
        self.name = name.lowercased()
        self.table = table?.lowercased()
        self.alias = alias?.lowercased()
    }

    public var sql: String {
        var sql = name
        if let table = self.table {
            sql = "\"\(table)\".\"\(sql)\""
        }
        if let alias = self.alias {
            sql += " AS \(alias)"
        }
        return sql
    }

    public var arguments: [Value] {
        return []
    }

    public var hashValue: Int {
        return self.stringToCompareForUniqueness.hashValue
    }

    public static func ==(lhs: QualifiedField, rhs: QualifiedField) -> Bool {
        return lhs.stringToCompareForUniqueness == rhs.stringToCompareForUniqueness
    }
}

extension QualifiedField: ParameterConvertible {
    public var sqlParameter: Parameter {
        return .field(self)
    }
}

private extension QualifiedField {
    var stringToCompareForUniqueness: String {
        if let alias = self.alias {
            return alias
        }
        else if let table = self.table {
            return "\(table).\(self.name)"
        }
        else {
            return self.name
        }
    }
}
