//
//  RowEncoder.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

public class RowEncoder<Key: CodingKey>: Encoder {
    let key: Key?
    public var setters: [String: ValueConvertible?] = [:]

    public var codingPath: [CodingKey] {
        guard let field = self.key else {
            return []
        }
        return [field]
    }

    public var userInfo: [CodingUserInfoKey: Any] = [:]

    public init(key: Key? = nil) {
        self.key = key
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        guard let key = self.key else {
            fatalError("single value containers at root are not supported")
        }

        return RowSingleValueEncodingContainer(encoder: self, key: key)
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("not supported")
    }

    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(RowKeyedEncodingContainer(encoder: self))
    }
}

