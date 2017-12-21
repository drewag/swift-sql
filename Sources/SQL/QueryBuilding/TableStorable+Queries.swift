//
//  TableStorable+Queries.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/9/17.
//

extension TableStorable {
    public static func field(_ field: Fields, alias: String? = nil) -> QualifiedField {
        return self.field(field.stringValue, alias: alias)
    }

    public static func field(_ field: CodingKey, alias: String? = nil) -> QualifiedField {
        return self.field(field.stringValue, alias: alias)
    }

    public static func field(_ field: String, alias: String? = nil) -> QualifiedField {
        return QualifiedField(name: field, table: self.tableName, alias: alias)
    }

    public static func select(_ selections: [Fields] = [], other: [Selectable] = []) -> SelectQuery<Self> {
        var finalSelections = [QueryComponent]()
        if selections.isEmpty && other.isEmpty {
            finalSelections.append(All())
        }
        for selection in selections {
            finalSelections.append(self.field(selection))
        }
        for selection in other {
            finalSelections.append(selection)
        }
        return SelectQuery(selections: finalSelections)
    }

    public static func selectCount(of selectable: Fields) -> SelectScalarQuery<Self> {
        return SelectScalarQuery(selection: Function.count(self.field(selectable)))
    }

    public static func selectCount(ofOther selectable: Selectable? = nil) -> SelectScalarQuery<Self> {
        return SelectScalarQuery(selection: Function.count(selectable ?? All()))
    }

    public static func selectMax(of selectable: Fields) -> SelectScalarQuery<Self> {
        let selection = Function.max(self.field(selectable))
        return SelectScalarQuery(selection: selection)
    }

    public static func selectMax(ofOther selectable: QualifiedField) -> SelectScalarQuery<Self> {
        return SelectScalarQuery(selection: Function.max(selectable))
    }

    public static func update(_ updates: [(Fields,ParameterConvertible?)]) -> UpdateTableQuery<Self> {
        var setters = [QualifiedField:ParameterConvertible?]()
        for (field, param) in updates {
            setters[self.field(field)] = param
        }
        return UpdateTableQuery().setting(setters)
    }

    public static func update(_ updates: [(QualifiedField,ParameterConvertible?)]) -> UpdateTableQuery<Self> {
        var setters = [QualifiedField:ParameterConvertible?]()
        for (field, param) in updates {
            setters[field] = param
        }
        return UpdateTableQuery().setting(setters)
    }

    public static func delete() -> DeleteQuery {
        return DeleteQuery(from: self.tableName)
    }

    public static func addColumn(forField field: Fields) -> AddColumn {
        guard let spec = field.sqlFieldSpec else {
            fatalError("No spec specified")
        }
        return AddColumn(to: self.tableName, with: spec)
    }

    public static func create(ifNotExists: Bool = false, fields: [Fields], extra: [FieldSpec?] = [], primaryKey: [String] = [], constraints: [Constraint] = []) -> CreateTable {
        return CreateTable(name: self.tableName, ifNotExists: ifNotExists, fields: fields.flatMap({$0.sqlFieldSpec}) + extra.flatMap({$0}), primaryKey: primaryKey, constraints: constraints)
    }

    public static func create(ifNotExists: Bool = false, fields: [FieldSpec], primaryKey: [String] = [], constraints: [Constraint] = []) -> CreateTable {
        return CreateTable(name: self.tableName, ifNotExists: ifNotExists, fields: fields, primaryKey: primaryKey, constraints: constraints)
    }

    public static func createIndex(for fields: [Fields], isUnique: Bool) -> AddIndex {
        return AddIndex(
            to: self.tableName,
            forColumns: fields.map({$0.stringValue}),
            isUnique: isUnique
        )
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
