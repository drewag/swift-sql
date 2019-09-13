//
//  RowEncoder.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

import Swiftlier

public class SQLEncoder: Encoder {
    var value = EncodedSQLValue.none
    public let codingPath: [CodingKey]

    public var userInfo: [CodingUserInfoKey: Any] = [:]

    public init(codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
    }

    public func generateSetters() throws -> [String: ValueConvertible] {
        var setters = [String: ValueConvertible]()
        switch self.value {
        case .array, .leaf, .none:
            throw SQLEncodingError.invalidRootValue
        case .dict(let dict):
            for (key, value) in dict {
                setters[key] = value.value
            }
        }
        return setters
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        return SQLSingleValueEncodingContainer(encoder: self, codingPath: self.codingPath)
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return SQLUnkeyedValueEncodingContainer(encoder: self, codingPath: self.codingPath)
    }

    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(SQLKeyedEncodingContainer<Key>(encoder: self))
    }
}

