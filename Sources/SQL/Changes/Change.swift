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

extension Connection {
    public func apply(_ change: DatabaseChange) throws {
        for query in change.forwardQueries {
            try self.run(query.statement, arguments: query.arguments)
        }
    }
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
            description += "UNIQUE (\""
            description += unique.joined(separator: "\",\"")
            description += "\")"
        }
        return description
    }
}

public struct FieldSpec: QueryComponent {
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

    public var sql: String {
        var description = "\"\(self.name)\" \(self.type.sql)"
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
            description += " DEFAULT \(try! defaultValue.rendered())"
        }
        if let references = self.references {
            description += " REFERENCES \(references.table)(\(references.field))"
            description += " ON DELETE \(references.onDelete.rawValue) ON UPDATE \(references.onUpdate.rawValue)"
        }
        return description
    }

    public var arguments: [Value] {
        return []
    }
}

public struct CustomChange: DatabaseChange {
    public let forwardQueries: [AnyQuery]
    public let revertQueries: [AnyQuery]?

    public init(forwardQuery: String, revertQuery: String? = nil) {
        let revert: AnyQuery?
        if let revertQuery = revertQuery {
            revert = RawEmptyQuery(sql: revertQuery)
        }
        else {
            revert = nil
        }
        self.init(forwardQuery: RawEmptyQuery(sql: forwardQuery), revertQuery: revert)
    }

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
    let ifNotExists: Bool

    public init(name: String, ifNotExists: Bool = false, fields: [FieldSpec], primaryKey: [String] = [], constraints: [Constraint] = []) {
        self.name = name.lowercased()
        self.fields = fields
        self.primaryKey = primaryKey
        self.constraints = constraints
        self.ifNotExists = ifNotExists
    }

    public var forwardQueries: [AnyQuery] {
        var query = "CREATE TABLE"
        if self.ifNotExists {
            query += " IF NOT EXISTS"
        }
        query += " \(name) ("
        var specs = self.fields.map({$0.sql})
        let arguments = self.fields.flatMap({$0.arguments})
        if !self.primaryKey.isEmpty {
            specs.append("PRIMARY KEY (\(self.primaryKey.joined(separator: ",")))")
        }
        specs += self.constraints.map({$0.description})
        query += specs.joined(separator: ",")
        query += ")"
        return [RawEmptyQuery(sql: query, arguments: arguments)]
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
        return [RawEmptyQuery(sql: "ALTER TABLE \(table) ADD COLUMN \(spec.sql)", arguments: spec.arguments)]
    }

    public var revertQueries: [AnyQuery]? {
        return [RawEmptyQuery(sql: "ALTER TABLE \(table) DROP COLUMN \(self.spec.name)")]
    }
}

public struct AddIndex: DatabaseChange {
    let table: String
    let columns: [String]
    let isUnique: Bool

    var name: String {
        return "index_\(self.table)_on_\(self.columns.joined(separator: "_"))"
    }

    public init(to table: String, forColumns columns: [String], isUnique: Bool) {
        self.table = table.lowercased()
        self.columns = columns
        self.isUnique = isUnique
    }

    public var forwardQueries: [AnyQuery] {
        var query = "CREATE"
        if self.isUnique {
            query += " UNIQUE"
        }
        query += " INDEX \(self.name) ON \(self.table) (\(self.columns.joined(separator: ",")))"
        return [RawEmptyQuery(sql: query)]
    }

    public var revertQueries: [AnyQuery]? {
        return [RawEmptyQuery(sql: "DROP INDEX \(self.name) ON \(self.table)")]
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

public struct InsertRow: DatabaseChange {
    let table: String
    let values: [String]

    public init(into table: String, values: [String]) {
        self.table = table.lowercased()
        self.values = values
    }

    public var forwardQueries: [AnyQuery] {
        var query = "INSERT INTO \(self.table) VALUES ("
        query += self.values.joined(separator: ",")
        query += ")"
        return [RawEmptyQuery(sql: query)]
    }

    public var revertQueries: [AnyQuery]? {
        return nil
    }
}

public struct CreateBoundedPseudoEncrypt: DatabaseChange {
    public static func callWith(value: String, min: Int, max: Int) -> Parameter {
        let count = max - min
        return .custom("bounded_pseudo_encrypt(\(value), \(count)) + \(min)")
    }

    public init() {}

    public var forwardQueries: [AnyQuery] {
        var queries = [String]()
        queries.append("""
            CREATE FUNCTION pseudo_encrypt_24(VALUE int) returns int AS $$
            DECLARE
            l1 int;
            l2 int;
            r1 int;
            r2 int;
            i int:=0;
            BEGIN
              l1:= (VALUE >> 12) & (4096-1);
              r1:= VALUE & (4096-1);
              WHILE i < 3 LOOP
                l2 := r1;
                r2 := l1 # ((((1366 * r1 + 150889) % 714025) / 714025.0) * (4096-1))::int;
                l1 := l2;
                r1 := r2;
                i := i + 1;
              END LOOP;
              RETURN ((l1 << 12) + r1);
            END;
            $$ LANGUAGE plpgsql strict immutable;
            """
        )
        queries.append("""
            CREATE FUNCTION bounded_pseudo_encrypt(VALUE int, MAX int) returns int AS $$
            BEGIN
              LOOP
                VALUE := pseudo_encrypt_24(VALUE);
                EXIT WHEN VALUE <= MAX;
              END LOOP;
              RETURN VALUE;
            END
            $$ LANGUAGE plpgsql strict immutable;
            """
        )
        return queries.map({RawEmptyQuery(sql: $0)})
    }

    public var revertQueries: [AnyQuery]? {
        return [RawEmptyQuery(sql: "DROP FUNCTION bounded_pseudo_encrypt(int,int);DROP FUNCTION pseudo_encrypt_24(int)")]
    }
}

public struct AlterColumn: DatabaseChange {
    public enum Action {
        case type(String)

        var query: String {
            switch self {
            case .type(let action):
                return "TYPE \(action)"
            }
        }
    }

    let tableName: String
    let columnName: String
    let from: Action
    let to: Action

    public var forwardQueries: [AnyQuery] {
        let query = "ALTER TABLE \(self.tableName) ALTER COLUMN \(self.columnName) " + self.to.query
        return [RawEmptyQuery(sql: query)]
    }

    public var revertQueries: [AnyQuery]? {
        let query = "ALTER TABLE \(self.tableName) ALTER COLUMN \(self.columnName) " + self.from.query
        return [RawEmptyQuery(sql: query)]
    }
}

public struct RenameColumn: DatabaseChange {
    let tableName: String
    let columnName: String
    let to: String

    public var forwardQueries: [AnyQuery] {
        return [RawEmptyQuery(sql: "ALTER TABLE \(self.tableName) RENAME COLUMN \(self.columnName) TO \(to)")]
    }

    public var revertQueries: [AnyQuery]? {
        return [RawEmptyQuery(sql: "ALTER TABLE \(self.tableName) RENAME COLUMN \(self.columnName) TO \(columnName)")]
    }
}
