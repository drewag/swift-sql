//
//  File.swift
//  
//
//  Created by Andrew J Wagner on 9/12/19.
//

import Foundation

struct SQLUnkeyedValueEncodingContainer: UnkeyedEncodingContainer {
    let encoder: SQLEncoder
    let codingPath: [CodingKey]
    var count: Int = 0

    init(encoder: SQLEncoder, codingPath: [CodingKey]) {
        self.encoder = encoder
        self.codingPath = codingPath
    }

    mutating func add(value: EncodedSQLValue) throws {
        switch self.encoder.value {
        case .leaf, .dict:
            throw SQLEncodingError.invalidValueCombination
        case .none:
            self.encoder.value = .array([value])
        case .array(var array):
            array.append(value)
            self.encoder.value = .array(array)
        }
        self.count += 1
    }

    mutating func encodeNil() throws {
        try self.add(value: .leaf(.null))
    }

    mutating func encode(_ value: Bool) throws {
        try self.add(value: .leaf(.bool(value)))
    }

    mutating func encode(_ value: String) throws {
        try self.add(value: .leaf(.string(value)))
    }

    mutating func encode(_ value: Double) throws {
        try self.add(value: .leaf(.double(value)))
    }

    mutating func encode(_ value: Float) throws {
        try self.add(value: .leaf(.float(value)))
    }

    mutating func encode(_ value: Int) throws {
        try self.add(value: .leaf(.int(value)))
    }

    mutating func encode(_ value: Int8) throws {
        try self.add(value: .leaf(.int8(value)))
    }

    mutating func encode(_ value: Int16) throws {
        try self.add(value: .leaf(.int16(value)))
    }

    mutating func encode(_ value: Int32) throws {
        try self.add(value: .leaf(.int32(value)))
    }

    mutating func encode(_ value: Int64) throws {
        try self.add(value: .leaf(.int64(value)))
    }

    mutating func encode(_ value: UInt) throws {
        try self.add(value: .leaf(.uint(value)))
    }

    mutating func encode(_ value: UInt8) throws {
        try self.add(value: .leaf(.uint8(value)))
    }

    mutating func encode(_ value: UInt16) throws {
        try self.add(value: .leaf(.uint16(value)))
    }

    mutating func encode(_ value: UInt32) throws {
        try self.add(value: .leaf(.uint32(value)))
    }

    mutating func encode(_ value: UInt64) throws {
        try self.add(value: .leaf(.uint64(value)))
    }

    mutating func encode<T>(_ value: T) throws where T : Encodable {
        if let date = value as? Date {
            try self.encode(date.iso8601DateTime)
        }
        else if let data = value as? Data {
            try self.add(value: .leaf(.data(data)))
        }
        else if let point = value as? Point {
            try self.add(value: .leaf(.point(x: point.x, y: point.y)))
        }
        else if let time = value as? Time {
            try self.add(value: .leaf(.time(hour: time.hour, minute: time.minute, second: time.second)))
        }
        else {
            let encoder = SQLEncoder(codingPath: self.codingPath)
            try value.encode(to: encoder)
            switch encoder.value {
            case .none:
                break
            default:
                try self.add(value: encoder.value)
            }
        }
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("encoding a nested container is not supported")
    }

    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("encoding a nested unkeyed container is not supported")
    }

    mutating func superEncoder() -> Encoder {
        return self.encoder
    }

}
