//
//  RowSingleValueEncodingContainer.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

import Foundation

struct SQLSingleValueEncodingContainer: SingleValueEncodingContainer {
    let encoder: SQLEncoder
    let codingPath: [CodingKey]

    init(encoder: SQLEncoder, codingPath: [CodingKey]) {
        self.encoder = encoder
        self.codingPath = codingPath
    }

    func set(value: EncodedSQLValue) throws {
        switch self.encoder.value {
        case .leaf, .none:
            self.encoder.value = value
        case .array, .dict:
            throw SQLEncodingError.invalidValueCombination
        }
    }

    func encodeNil() throws {
        try self.set(value: .leaf(.null))
    }

    func encode(_ value: Bool) throws {
        try self.set(value: .leaf(.bool(value)))
    }

    func encode(_ value: Int) throws {
        try self.set(value: .leaf(.int(value)))
    }

    func encode(_ value: Int8) throws {
        try self.set(value: .leaf(.int8(value)))
    }

    func encode(_ value: Int16) throws {
        try self.set(value: .leaf(.int16(value)))
    }

    func encode(_ value: Int32) throws {
        try self.set(value: .leaf(.int32(value)))
    }

    func encode(_ value: Int64) throws {
        try self.set(value: .leaf(.int64(value)))
    }

    func encode(_ value: UInt) throws {
        try self.set(value: .leaf(.uint(value)))
    }

    func encode(_ value: UInt8) throws {
        try self.set(value: .leaf(.uint8(value)))
    }

    func encode(_ value: UInt16) throws {
        try self.set(value: .leaf(.uint16(value)))
    }

    func encode(_ value: UInt32) throws {
        try self.set(value: .leaf(.uint32(value)))
    }

    func encode(_ value: UInt64) throws {
        try self.set(value: .leaf(.uint64(value)))
    }

    func encode(_ value: Float) throws {
        try self.set(value: .leaf(.float(value)))
    }

    func encode(_ value: Double) throws {
        try self.set(value: .leaf(.double(value)))
    }

    func encode(_ value: String) throws {
        try self.set(value: .leaf(.string(value)))
    }

    func encode<T>(_ value: T) throws where T : Encodable {
        if let date = value as? Date {
            try self.encode(date.iso8601DateTime)
        }
        else if let data = value as? Data {
            try self.set(value: .leaf(.data(data)))
        }
        else if let point = value as? Point {
            try self.set(value: .leaf(.point(x: point.x, y: point.y)))
        }
        else if let time = value as? Time {
            try self.set(value: .leaf(.time(hour: time.hour, minute: time.minute, second: time.second)))
        }
        else {
            let encoder = SQLEncoder(codingPath: self.codingPath)
            try value.encode(to: encoder)
            switch encoder.value {
            case .none:
                break
            default:
                try self.set(value: encoder.value)
            }
        }
    }
}
