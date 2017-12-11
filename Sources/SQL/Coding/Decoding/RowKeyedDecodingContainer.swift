//
//  RowKeyedDecodingContainer.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

import Foundation

class RowKeyedDecodingContainer<Query: RowReturningQuery, MyKey: CodingKey>: KeyedDecodingContainerProtocol {
    typealias Key = MyKey

    let userInfo: [CodingUserInfoKey:Any]
    let codingPath: [CodingKey] = []
    let row: Row<Query>

    init(row: Row<Query>, userInfo: [CodingUserInfoKey:Any]) {
        self.row = row
        self.userInfo = userInfo
    }

    var allKeys: [Key] {
        return self.row.columns.flatMap({Key(stringValue: $0)})
    }

    func contains(_ key: Key) -> Bool {
        let string: String? = (try? self.row.getIfExists(column: key.stringValue.lowercased())) ?? nil
        return string != nil
    }

    func decodeNil(forKey key: Key) throws -> Bool {
        return !self.contains(key)
    }

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        return try self.row.get(column: key.stringValue.lowercased())
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Swift.Decodable {
        guard type != Date.self else {
            guard let date = try self.decode(String.self, forKey: key).iso8601DateTime else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "invalid date")
            }
            return date as! T
        }

        guard type != Data.self else {
            return try self.decode(String.self, forKey: key).data(using: .utf8)! as! T
        }

        let decoder = RowDecoder(row: self.row, codingPath: self.codingPath + [key])
        decoder.userInfo = self.userInfo
        return try T(from: decoder)
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding nested containers is not supported"))
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding unkeyed containers is not supported"))
    }

    func superDecoder() throws -> Swift.Decoder {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding super encoders containers is not supported"))
    }

    func superDecoder(forKey key: Key) throws -> Swift.Decoder {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "decoding super decoders is not supported"))
    }
}

