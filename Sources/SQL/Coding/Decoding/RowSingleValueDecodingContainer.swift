//
//  RowSingleValueDecodingContainer.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

import Foundation
import Swiftlier

class RowSingleValueDecodingContainer<Query: RowReturningQuery>: SingleValueDecodingContainer {
    let userInfo: [CodingUserInfoKey:Any]
    let codingPath: [CodingKey]
    let row: Row<Query>

    func key() throws -> String {
        return codingPath.last!.stringValue.lowercased()
    }

    init(row: Row<Query>, codingPath: [CodingKey], userInfo: [CodingUserInfoKey:Any]) {
        self.codingPath = codingPath
        self.row = row
        self.userInfo = userInfo
    }

    func decodeNil() -> Bool {
        return false
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        return try self.row.get(column: try key())
    }

    func decode(_ type: Int.Type) throws -> Int {
        return try self.row.get(column: try key())
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        return try self.row.get(column: try key())
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        return try self.row.get(column: try key())
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        return try self.row.get(column: try key())
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        return try self.row.get(column: try key())
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        return try self.row.get(column: try key())
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try self.row.get(column: try key())
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try self.row.get(column: try key())
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try self.row.get(column: try key())
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try self.row.get(column: try key())
    }

    func decode(_ type: Float.Type) throws -> Float {
        return try self.row.get(column: try key())
    }

    func decode(_ type: Double.Type) throws -> Double {
        return try self.row.get(column: try key())
    }

    func decode(_ type: String.Type) throws -> String {
        return try self.row.get(column: try key())
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        guard type != Date.self else {
            guard let date = try self.decode(String.self).iso8601DateTime else {
                throw DecodingError.dataCorruptedError(in: self, debugDescription: "invalid date")
            }
            return date as! T
        }

        guard let data = try self.decode(String.self).data(using: .utf8) else {
            throw DecodingError.dataCorruptedError(in: self, debugDescription: "an unsupported type was found")
        }

        guard type != Data.self else {
            return data as! T
        }

        let decoder = JSONDecoder()
        decoder.userInfo = self.userInfo
        decoder.dateDecodingStrategy = .formatted(ISO8601DateTimeFormatters.first!)
        return try decoder.decode(T.self, from: data)
    }
}

