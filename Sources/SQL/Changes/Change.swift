//
//  Change.swift
//  SwiftServePostgresPackageDescription
//
//  Created by Andrew J Wagner on 12/5/17.
//


public protocol DatabaseChange {
    var forwardQueries: [AnyQuery] {get}
    var revertQueries: [AnyQuery]? {get}
}

public struct FieldReference {
    public enum Action: String {
        case none = "NO ACTION"
        case cascade = "CASCADE"
        case setNull = "SET NULL"
        case setDefault = "SET DEFAULT"
    }

    let table: String
    let field: String
    let onDelete: Action
    let onUpdate: Action

    init(table: String, field: String, onDelete: Action = .none, onUpdate: Action = .none) {
        self.table = table
        self.field = field
        self.onDelete = onDelete
        self.onUpdate = onUpdate
    }

    public static func field(_ field: String, in table: String, onDelete: Action = .none, onUpdate: Action = .none) -> FieldReference {
        return FieldReference(table: table, field: field, onDelete: onDelete, onUpdate: onUpdate)
    }
}

public struct Constraint: CustomStringConvertible {
    public enum Kind {
        case unique([String])
    }

    let name: String
    let kind: Kind

    public init(name: String, kind: Kind) {
        self.name = name
        self.kind = kind
    }

    public var description: String {
        var description = "CONSTRAINT \(self.name) "
        switch kind {
        case .unique(let unique):
            description += "UNIQUE ("
            description += unique.joined(separator: ",")
            description += ")"
        }
        return description
    }
}

public struct FieldSpec: CustomStringConvertible {
    let name: String
    let allowNull: Bool
    let isUnique: Bool
    let isPrimaryKey: Bool
    let type: DataType
    let references: FieldReference?
    let defaultValue: Parameter?

    public init(name: String, type: DataType, allowNull: Bool = true, isUnique: Bool = false, references: FieldReference? = nil, default: Parameter? = nil) {
        self.name = name.lowercased()
        self.type = type
        self.allowNull = allowNull
        self.isUnique = isUnique
        self.isPrimaryKey = false
        self.references = references
        self.defaultValue = `default`
    }

    public init(name: String, type: DataType, isPrimaryKey: Bool) {
        self.name = name.lowercased()
        self.type = type
        self.isPrimaryKey = isPrimaryKey

        // Setting these will mean they won't be added to the command
        self.allowNull = true
        self.isUnique = false
        self.defaultValue = nil
        self.references = nil
    }

    public var description: String {
        var description = "\(self.name) \(self.type.sql)"
        if isPrimaryKey {
            description += " PRIMARY KEY"
        }
        if isUnique {
            description += " UNIQUE"
        }
        if !self.allowNull {
            description += " NOT NULL"
        }
        if let defaultValue = self.defaultValue {
            description += " DEFAULT \(defaultValue.sql)"
        }
        if let references = self.references {
            description += " REFERENCES \(references.table)(\(references.field))"
            description += " ON DELETE \(references.onDelete.rawValue) ON UPDATE \(references.onUpdate.rawValue)"
        }
        return description
    }
}

public struct CustomChange: DatabaseChange {
    public let forwardQueries: [AnyQuery]
    public let revertQueries: [AnyQuery]?

    public init(forwardQuery: AnyQuery, revertQuery: AnyQuery? = nil) {
        self.forwardQueries = [forwardQuery]
        if let revert = revertQuery {
            self.revertQueries = [revert]
        }
        else {
            self.revertQueries = nil
        }
    }

    public init(forwardQueries: [AnyQuery], revertQueries: [AnyQuery]? = nil) {
        self.forwardQueries = forwardQueries
        self.revertQueries = revertQueries
    }
}

public struct CreateSequence: DatabaseChange {
    let name: String

    public init(name: String) {
        self.name = name.lowercased()
    }

    public var forwardQueries: [AnyQuery] {
        return [RawEmptyQuery(sql: "CREATE SEQUENCE \(name)")]
    }

    public var revertQueries: [AnyQuery]? {
        return [RawEmptyQuery(sql: "DROP SEQUENCE \(name)")]
    }
}

public struct CreateTable: DatabaseChange {
    let name: String
    let fields: [FieldSpec]
    let constraints: [Constraint]
    let primaryKey: [String]

    public init(name: String, fields: [FieldSpec], primaryKey: [String] = [], constraints: [Constraint] = []) {
        self.name = name.lowercased()
        self.fields = fields
        self.primaryKey = primaryKey
        self.constraints = constraints
    }

    public var forwardQueries: [AnyQuery] {
        var query = "CREATE TABLE \(name) ("
        var specs = self.fields.map({$0.description})
        if !self.primaryKey.isEmpty {
            specs.append("PRIMARY KEY (\(self.primaryKey.joined(separator: ",")))")
        }
        specs += self.constraints.map({$0.description})
        query += specs.joined(separator: ",")
        query += ")"
        return [RawEmptyQuery(sql: query)]
    }

    public var revertQueries: [AnyQuery]? {
        return [RawEmptyQuery(sql: "DROP TABLE \(self.name)")]
    }
}

public struct AddColumn: DatabaseChange {
    let table: String
    let spec: FieldSpec

    public init(to table: String, with spec: FieldSpec) {
        self.table = table.lowercased()
        self.spec = spec
    }

    public var forwardQueries: [AnyQuery] {
        return [RawEmptyQuery(sql: "ALTER TABLE \(table) ADD COLUMN \(spec.description)")]
    }

    public var revertQueries: [AnyQuery]? {
        return [RawEmptyQuery(sql: "ALTER TABLE \(table) DROP COLUMN \(self.spec.name)")]
    }
}

public struct RemoveColumn: DatabaseChange {
    let table: String
    let name: String

    public init(from table: String, named name: String) {
        self.table = table.lowercased()
        self.name = name.lowercased()
    }

    public var forwardQueries: [AnyQuery] {
        return [RawEmptyQuery(sql: "ALTER TABLE \(table) DROP COLUMN \(name)")]
    }

    public var revertQueries: [AnyQuery]? {
        return nil
    }
}
