//
//  RowSingleValueEncodingContainer.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

class RowSingleValueEncodingContainer<Key: CodingKey, EncoderKey: CodingKey>: RowKeyedEncodingContainer<Key, EncoderKey>, SingleValueEncodingContainer {
    let key: Key

    init(encoder: RowEncoder<EncoderKey>, key: Key) {
        self.key = key

        super.init(encoder: encoder)
    }

    func encodeNil() throws {
        try self.encodeNil(forKey: self.key)
    }

    func encode(_ value: Bool) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: Int) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: Int8) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: Int16) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: Int32) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: Int64) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: UInt) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: UInt8) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: UInt16) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: UInt32) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: UInt64) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: Float) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: Double) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode(_ value: String) throws {
        try self.encode(value, forKey: self.key)
    }

    func encode<T>(_ value: T) throws where T : Encodable {
        try self.encode(value, forKey: self.key)
    }
}

