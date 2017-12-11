//
//  RowDecoder.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

class RowDecoder<Query: RowReturningQuery>: Decoder {
    let row: Row<Query>
    let codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any] = [:]

    init(row: Row<Query>, codingPath: [CodingKey] = []) {
        self.row = row
        self.codingPath = codingPath
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(RowKeyedDecodingContainer(row: self.row, userInfo: self.userInfo))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw SQLError(message: "decoding an unkeyed container is not supported by the SQLiteDecoder")
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return RowSingleValueDecodingContainer(row: self.row, codingPath: self.codingPath, userInfo: self.userInfo)
    }
}

