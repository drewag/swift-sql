//
//  RowKeyedEncodingContainer.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

import Foundation

struct SQLKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol  {
    let encoder: SQLEncoder
    let codingPath: [CodingKey] = []

    init(encoder: SQLEncoder) {
        self.encoder = encoder
    }

    func superEncoder() -> Swift.Encoder {
        return self.encoder
    }

    func superEncoder(forKey key: Key) -> Swift.Encoder {
        return self.encoder
    }

    func set(value: EncodedSQLValue, forKey key: Key) throws {
        switch self.encoder.value {
        case .none:
            self.encoder.value = .dict([key.stringValue:value])
        case .leaf, .array:
            throw SQLEncodingError.invalidValueCombination
        case .dict(var existing):
            existing[key.stringValue] = value
            self.encoder.value = .dict(existing)
        }
    }

    func encodeNil(forKey key: Key) throws {
        try self.set(value: .leaf(.null), forKey: key)
    }

    func encode(_ value: Int, forKey key: Key) throws {
        try self.set(value: .leaf(.int(value)), forKey: key)
    }

    func encode(_ value: Bool, forKey key: Key) throws {
        try self.set(value: .leaf(.bool(value)), forKey: key)
    }

    func encode(_ value: Float, forKey key: Key) throws {
        try self.set(value: .leaf(.float(value)), forKey: key)
    }

    func encode(_ value: Double, forKey key: Key) throws {
        try self.set(value: .leaf(.double(value)), forKey: key)
    }

    func encode(_ value: String, forKey key: Key) throws {
        try self.set(value: .leaf(.string(value)), forKey: key)
    }

    func encode(_ value: Int8, forKey key: Key) throws {
        try self.set(value: .leaf(.int8(value)), forKey: key)
    }

    func encode(_ value: Int16, forKey key: Key) throws {
        try self.set(value: .leaf(.int16(value)), forKey: key)
    }

    func encode(_ value: Int32, forKey key: Key) throws {
        try self.set(value: .leaf(.int32(value)), forKey: key)
    }

    func encode(_ value: Int64, forKey key: Key) throws {
        try self.set(value: .leaf(.int64(value)), forKey: key)
    }

    func encode(_ value: UInt, forKey key: Key) throws {
        try self.set(value: .leaf(.uint(value)), forKey: key)
    }

    func encode(_ value: UInt8, forKey key: Key) throws {
        try self.set(value: .leaf(.uint8(value)), forKey: key)
    }

    func encode(_ value: UInt16, forKey key: Key) throws {
        try self.set(value: .leaf(.uint16(value)), forKey: key)
    }

    func encode(_ value: UInt32, forKey key: Key) throws {
        try self.set(value: .leaf(.uint32(value)), forKey: key)
    }

    func encode(_ value: UInt64, forKey key: Key) throws {
        try self.set(value: .leaf(.uint64(value)), forKey: key)
    }

    func encode<T>(_ value: T, forKey key: Key) throws where T : Swift.Encodable {
        if let date = value as? Date {
            try self.encode(date.iso8601DateTime, forKey: key)
        }
        else if let data = value as? Data {
            try self.set(value: .leaf(.data(data)), forKey: key)
        }
        else if let point = value as? Point {
            try self.set(value: .leaf(.point(x: point.x, y: point.y)), forKey: key)
        }
        else if let time = value as? Time {
            try self.set(value: .leaf(.time(hour: time.hour, minute: time.minute, second: time.second)), forKey: key)
        }
        else {
            let encoder = SQLEncoder(codingPath: self.codingPath + [key])
            try value.encode(to: encoder)
            switch encoder.value {
            case .none:
                break
            default:
                try self.set(value: encoder.value, forKey: key)
            }
        }
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("encoding a nested container is not supported")
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError("encoding nested values is not supported")
    }
}

