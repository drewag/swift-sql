//
//  RowDecoder.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

public class RowDecoder<Query: RowReturningQuery>: Decoder {
    let row: Row<Query>
    public let codingPath: [CodingKey]
    public var userInfo: [CodingUserInfoKey: Any] = [:]
    var tableName: String?

    public init(row: Row<Query>, forTableNamed tableName: String?, codingPath: [CodingKey] = []) {
        self.row = row
        self.codingPath = codingPath
        self.tableName = tableName
    }

    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(RowKeyedDecodingContainer(row: self.row, decoder: self, tableName: self.tableName))
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw SQLError(message: "decoding an unkeyed container is not supported by the SQLiteDecoder")
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return RowSingleValueDecodingContainer(row: self.row, codingPath: self.codingPath, userInfo: self.userInfo, tableName: self.tableName)
    }
}

