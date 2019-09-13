//
//  File.swift
//  
//
//  Created by Andrew J Wagner on 9/13/19.
//

import Foundation
import SQL

struct LeafOnly: Codable {
    var int: Int = 1
    var bool: Bool = true
    var float: Float = 2.3
    var double: Double = 4.5
    var string: String = "my string"
    var int8: Int8 = 6
    var int16: Int16 = 7
    var int32: Int32 = 8
    var int64: Int64 = 9
    var uint: UInt = 10
    var uint8: UInt8 = 11
    var uint16: UInt16 = 12
    var uint32: UInt32 = 13
    var uint64: UInt64 = 14
    var point = Point(x: 15, y: 16)
    var time = Time(hour: 6, minute: 7, second: 8)
    var date = Date(timeIntervalSince1970: 0)
    var data = "Hello".data(using: .utf8)!
}

struct SingleValueContainers: Codable {
    var int = SingleValueCodable<Int>(1)
    var bool = SingleValueCodable<Bool>(true)
    var float = SingleValueCodable<Float>(2.3)
    var double = SingleValueCodable<Double>(4.5)
    var string = SingleValueCodable<String>("my string")
    var int8 = SingleValueCodable<Int8>(6)
    var int16 = SingleValueCodable<Int16>(7)
    var int32 = SingleValueCodable<Int32>(8)
    var int64 = SingleValueCodable<Int64>(9)
    var uint = SingleValueCodable<UInt>(10)
    var uint8 = SingleValueCodable<UInt8>(11)
    var uint16 = SingleValueCodable<UInt16>(12)
    var uint32 = SingleValueCodable<UInt32>(13)
    var uint64 = SingleValueCodable<UInt64>(14)
    var point = SingleValueCodable(Point(x: 15, y: 16))
    var time = SingleValueCodable(Time(hour: 6, minute: 7, second: 8))
    var date = SingleValueCodable(Date(timeIntervalSince1970: 0))
    var data = SingleValueCodable("Hello".data(using: .utf8)!)
}

struct Optionals: Codable {
    var string1: String? = "is there"
    var string2: String? = nil

    enum CodingKeys: String, CodingKey {
        case string1, string2
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.string1, forKey: .string1)
        try container.encode(self.string2, forKey: .string2)
    }
}

struct Embedded: Codable {
    var string: String = "my string"
    var int: Int = 1
    var double: Double = 2.3
    var bool: Bool = true
    var null: String? = nil
    var point = Point(x: 4, y: 5)
    var time = Time(hour: 6, minute: 7, second: 8)
    var date = Date(timeIntervalSince1970: 0)
    var data = "Hello".data(using: .utf8)!
}

struct Dict: Codable {
    var embedded = Embedded()
}

struct Arr: Codable {
    var embedded = [Embedded](repeating: Embedded(), count: 2)
}

struct SingleValueCodable<Value: Codable>: Codable {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(Value.self)
    }
}
