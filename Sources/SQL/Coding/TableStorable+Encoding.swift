//
//  TableStorable+Encoding.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/8/17.
//

import Swiftlier

extension TableStorable where Self: Codable {
    public func insert() throws -> ConstrainedInsertQuery<Self> {
        let encoder = RowEncoder<Fields>()
        encoder.userInfo.location = .local
        encoder.userInfo.purpose = .create
        try self.encode(to: encoder)
        var insert = ConstrainedInsertQuery<Self>(setters: [:])
        for (key, value) in encoder.setters {
            insert.setters[QualifiedField(name: key.lowercased()).sql] = value?.sqlValue ?? .null
        }
        return insert
    }

    public func update() throws -> UpdateTableQuery<Self> {
        let encoder = RowEncoder<Fields>()
        encoder.userInfo.location = .local
        encoder.userInfo.purpose = .update
        try self.encode(to: encoder)
        print(encoder.setters)
        var update = UpdateTableQuery<Self>()
        for (key, value) in encoder.setters {
            update.setters[QualifiedField(name: key.lowercased()).sql] = value?.sqlValue ?? .null
        }
        return update
    }
}
