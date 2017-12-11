//
//  RowEncoder.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

class RowEncoder<Key: CodingKey>: Encoder {
    let key: Key?
    var setters: [String: ValueConvertible?] = [:]

    var codingPath: [CodingKey] {
        guard let field = self.key else {
            return []
        }
        return [field]
    }

    var userInfo: [CodingUserInfoKey: Any] = [:]

    init(key: Key? = nil) {
        self.key = key
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        guard let key = self.key else {
            fatalError("single value containers at root are not supported")
        }

        return RowSingleValueEncodingContainer(encoder: self, key: key)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("not supported")
    }

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(RowKeyedEncodingContainer(encoder: self))
    }
}

