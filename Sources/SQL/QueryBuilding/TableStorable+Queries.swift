//
//  TableStorable+Queries.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/9/17.
//

extension TableStorable {
    public static func field(_ field: Fields, alias: String? = nil) -> QualifiedField {
        return QualifiedField(name: field.stringValue, table: self.tableName, alias: alias)
    }

    public static func select(_ selections: [Selectable<Self>] = [.all]) -> SelectQuery<Self> {
        return SelectQuery(selections: selections)
    }

    public static func selectCount() -> SelectCountQuery<Self> {
        return SelectCountQuery(selections: [Selectable<Self>.count(.all)])
    }

    public static func update(_ updates: [(Fields,ParameterConvertible?)]) -> UpdateTableQuery<Self> {
        var setters = [QualifiedField:ParameterConvertible?]()
        for (field, param) in updates {
            setters[self.field(field)] = param
        }
        return UpdateTableQuery().setting(setters)
    }

    public static func delete() -> DeleteQuery {
        return DeleteQuery(from: self.tableName)
    }

    public static func create(fields: [Fields], extra: [FieldSpec] = [], primaryKey: [String] = [], constraints: [Constraint] = []) -> CreateTable {
        return CreateTable(name: self.tableName, fields: fields.flatMap({$0.sqlFieldSpec}) + extra, primaryKey: primaryKey, constraints: constraints)
    }

    public static func addColumn(forField field: Fields) -> AddColumn {
        guard let spec = field.sqlFieldSpec else {
            fatalError("No spec specified")
        }
        return AddColumn(to: self.tableName, with: spec)
    }

    public static func create(fields: [FieldSpec], primaryKey: [String] = [], constraints: [Constraint] = []) -> CreateTable {
        return CreateTable(name: self.tableName, fields: fields, primaryKey: primaryKey, constraints: constraints)
    }

    public static func addColumn(withSpec spec: FieldSpec) -> AddColumn {
        return AddColumn(to: self.tableName, with: spec)
    }
}

extension Field {
    public func spec(dataType: DataType, allowNull: Bool = true, isUnique: Bool = false, references: FieldReference? = nil, defaultValue: ParameterConvertible? = nil) -> FieldSpec {
        return FieldSpec(name: self.stringValue, type: dataType, allowNull: allowNull, isUnique: isUnique, references: references, default: defaultValue?.sqlParameter)
    }

    public func spec(dataType: DataType, isPrimaryKey: Bool) -> FieldSpec {
        return FieldSpec(name: self.stringValue, type: dataType, isPrimaryKey: isPrimaryKey)
    }

    public func spec<R: TableStorable>(
        referencing: R.Fields,
        in: R.Type,
        onDelete: FieldReference.Action = .none,
        onUpdate: FieldReference.Action = .none,
        allowNull: Bool = true,
        isUnique: Bool = false,
        defaultValue: ParameterConvertible? = nil
        ) -> FieldSpec?
    {
        guard let spec = referencing.sqlFieldSpec else {
            return nil
        }

        return FieldSpec(
            name: self.stringValue,
            type: spec.type,
            allowNull: allowNull,
            isUnique: isUnique,
            references: .field(referencing.stringValue, in: R.tableName, onDelete: onDelete, onUpdate: onUpdate),
            default: defaultValue?.sqlParameter
        )
    }
}
