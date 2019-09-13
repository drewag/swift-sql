//
//  TableStorable+Encoding.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/8/17.
//

import Swiftlier

extension TableStorable where Self: Encodable {
    public func insert(userInfo: [CodingUserInfoKey:Any] = [:], otherSetters: [QualifiedField:ParameterConvertible?] = [:]) throws -> ConstrainedInsertQuery<Self> {
        let encoder = SQLEncoder()
        encoder.userInfo = userInfo
        encoder.userInfo.location = .local
        encoder.userInfo.purpose = .create
        try self.encode(to: encoder)
        var insert = ConstrainedInsertQuery<Self>()
        for (key, value) in try encoder.generateSetters() {
            insert.setters[QualifiedField(name: key.lowercased()).sql] = value.sqlValue
        }
        return insert
    }

    public func update(userInfo: [CodingUserInfoKey:Any] = [:]) throws -> UpdateTableQuery<Self> {
        let encoder = SQLEncoder()
        encoder.userInfo = userInfo
        encoder.userInfo.location = .local
        encoder.userInfo.purpose = .update
        try self.encode(to: encoder)
        var update = UpdateTableQuery<Self>()
        for (key, value) in try encoder.generateSetters() {
            update.setters[QualifiedField(name: key.lowercased()).sql] = value.sqlValue
        }
        return update
    }
}
