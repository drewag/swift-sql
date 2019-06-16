//
//  RowKeyedEncodingContainer.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

import Foundation

class RowKeyedEncodingContainer<Key: CodingKey, EncoderKey: CodingKey>: KeyedEncodingContainerProtocol  {
    let encoder: RowEncoder<EncoderKey>
    let codingPath: [CodingKey] = []

    init(encoder: RowEncoder<EncoderKey>) {
        self.encoder = encoder
    }

    func superEncoder() -> Swift.Encoder {
        return self.encoder
    }

    func superEncoder(forKey key: Key) -> Swift.Encoder {
        return self.encoder
    }

    func encodeNil(forKey key: Key) throws {
        let none: ValueConvertible? = nil
        self.encoder.setters[key.stringValue] = none
    }

    func encode(_ value: Int, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: Bool, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: Float, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: Double, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: String, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode<T>(_ value: T, forKey key: Key) throws where T : Swift.Encodable {
        guard !(Mirror(reflecting: value).displayStyle == .optional) else {
            let encoder = RowEncoder(key: key)
            encoder.userInfo = self.encoder.userInfo
            try value.encode(to: encoder)
            for (key, value) in encoder.setters {
                self.encoder.setters[key] = value
            }
            return
        }

        if let date = value as? Date {
            try self.encode(date.iso8601DateTime, forKey: key)
        }
        else if let data = value as? Data {
            self.encoder.setters[key.stringValue] = data
        }
        else if let string = value as? String {
            self.encoder.setters[key.stringValue] = string
        }
        else if let point = value as? Point {
            self.encoder.setters[key.stringValue] = point
        }
        else {
            do {
                let encoder = JSONEncoder()
                encoder.userInfo = self.encoder.userInfo
                self.encoder.setters[key.stringValue] = try encoder.encode(value)
            }
            catch {
                let encoder = RowEncoder(key: key)
                try value.encode(to: encoder)
                for (key, value) in encoder.setters {
                    self.encoder.setters[key] = value
                }
            }
        }
    }

    func encode(_ value: Int8, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: Int16, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: Int32, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: Int64, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: UInt, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: UInt8, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: UInt16, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: UInt32, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func encode(_ value: UInt64, forKey key: Key) throws {
        self.encoder.setters[key.stringValue] = value
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("encoding a nested container is not supported")
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError("encoding nested values is not supported")
    }
}

