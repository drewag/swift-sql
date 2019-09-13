//
//  RowSingleValueDecodingContainer.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

import Foundation
import Swiftlier

class SQLSingleValueDecodingContainer<Query: RowReturningQuery>: SingleValueDecodingContainer, SQLDecodingContainer {
    let userInfo: [CodingUserInfoKey:Any]
    let codingPath: [CodingKey]
    let row: Row<Query>
    let tableName: String?

    func keys() throws -> [String] {
        var keys = [codingPath.last!.stringValue.lowercased()]
        if let tableName = self.tableName {
            keys.append("\(tableName)__\(codingPath.last!.stringValue.lowercased())")
        }
        return keys
    }

    init(row: Row<Query>, codingPath: [CodingKey], userInfo: [CodingUserInfoKey:Any], tableName: String?) {
        self.codingPath = codingPath
        self.row = row
        self.userInfo = userInfo
        self.tableName = tableName
    }

    func decodeNil() -> Bool {
        return false
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: Int.Type) throws -> Int {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: UInt.Type) throws -> UInt {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: UInt32.Type) throws -> UInt32 {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: Float.Type) throws -> Float {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: Double.Type) throws -> Double {
        return try self.row.get(column: try keys())
    }

    func decode(_ type: String.Type) throws -> String {
        return try self.row.get(column: try keys())
    }

    func decode<D>(_ type: D.Type) throws -> D where D : Decodable {
        guard type != Date.self else {
            guard let date = try self.decode(String.self).iso8601DateTime else {
                throw DecodingError.dataCorruptedError(in: self, debugDescription: "invalid date")
            }
            return date as! D
        }

        guard type != Data.self else {
            return (try self.decode(String.self).data(using: .utf8) ?? Data()) as! D
        }

        guard type != Point.self else {
            let data = try self.decode(Data.self)
            guard let point = self.point(from: data) else {
                throw DecodingError.dataCorruptedError(in: self, debugDescription: "invalid point")
            }
            return point as! D
        }

        do {
            let tableName = (type as? TableDecodable.Type)?.tableName ?? self.tableName
            let decoder = SQLDecoder(row: self.row, forTableNamed: tableName, codingPath: self.codingPath)
            decoder.userInfo = self.userInfo
            return try D(from: decoder)
        }
        catch {
            guard let data = try self.decode(String.self).data(using: .utf8) else {
                throw DecodingError.dataCorruptedError(in: self, debugDescription: "an unsupported type was found")
            }

            guard type != Data.self else {
                return data as! D
            }

            let decoder = JSONDecoder()
            decoder.userInfo = self.userInfo
            decoder.dateDecodingStrategy = .formatted(ISO8601DateTimeFormatters.first!)
            return try decoder.decode(D.self, from: data)
        }
    }
}

