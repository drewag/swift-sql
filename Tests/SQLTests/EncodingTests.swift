//
//  File.swift
//  
//
//  Created by Andrew J Wagner on 9/11/19.
//

import XCTest
@testable import SQL

class EncodingTests: XCTestCase {
    func testLeafsOnly() throws {
        let encoder = SQLEncoder()
        try LeafOnly().encode(to: encoder)

        let setters = try encoder.generateSetters()
        XCTAssertEqual(setters.count, 18)
        if setters.count == 18 {
            AssertEqual(setters["int"], .int(1))
            AssertEqual(setters["bool"], .bool(true))
            AssertEqual(setters["float"], .float(2.3))
            AssertEqual(setters["double"], .double(4.5))
            AssertEqual(setters["string"], .string("my string"))
            AssertEqual(setters["int8"], .int8(6))
            AssertEqual(setters["int16"], .int16(7))
            AssertEqual(setters["int32"], .int32(8))
            AssertEqual(setters["int64"], .int64(9))
            AssertEqual(setters["uint"], .uint(10))
            AssertEqual(setters["uint8"], .uint8(11))
            AssertEqual(setters["uint16"], .uint16(12))
            AssertEqual(setters["uint32"], .uint32(13))
            AssertEqual(setters["uint64"], .uint64(14))
            AssertEqual(setters["point"], .point(x: 15, y: 16))
            AssertEqual(setters["time"], .time(hour: 6, minute: 7, second: 8))
            AssertEqual(setters["date"], .string("1970-01-01T00:00:00.0Z"))
            AssertEqual(setters["data"], .data("Hello".data(using: .utf8)!))
        }
    }

    func testLeaf() throws {
        let encoder = SQLEncoder()
        try "hello".encode(to: encoder)
        XCTAssertThrowsError(try encoder.generateSetters(), "", { XCTAssertEqual("\($0)", "Failed to encode for SQL: The root value encoded must be keyed.")})
    }

    func testSingleValueContainers() throws {
        let encoder = SQLEncoder()
        try SingleValueContainers().encode(to: encoder)

        let setters = try encoder.generateSetters()
        XCTAssertEqual(setters.count, 18)
        if setters.count == 18 {
            AssertEqual(setters["int"], .int(1))
            AssertEqual(setters["bool"], .bool(true))
            AssertEqual(setters["float"], .float(2.3))
            AssertEqual(setters["double"], .double(4.5))
            AssertEqual(setters["string"], .string("my string"))
            AssertEqual(setters["int8"], .int8(6))
            AssertEqual(setters["int16"], .int16(7))
            AssertEqual(setters["int32"], .int32(8))
            AssertEqual(setters["int64"], .int64(9))
            AssertEqual(setters["uint"], .uint(10))
            AssertEqual(setters["uint8"], .uint8(11))
            AssertEqual(setters["uint16"], .uint16(12))
            AssertEqual(setters["uint32"], .uint32(13))
            AssertEqual(setters["uint64"], .uint64(14))
            AssertEqual(setters["point"], .point(x: 15, y: 16))
            AssertEqual(setters["time"], .time(hour: 6, minute: 7, second: 8))
            AssertEqual(setters["date"], .string("1970-01-01T00:00:00.0Z"))
            AssertEqual(setters["data"], .data("Hello".data(using: .utf8)!))
        }
    }

    func testOptionals() throws {
        let encoder = SQLEncoder()
        try Optionals().encode(to: encoder)

        let setters = try encoder.generateSetters()
        XCTAssertEqual(setters.count, 2)
        if setters.count == 2 {
            AssertEqual(setters["string1"], .string("is there"))
            AssertEqual(setters["string2"], .null)
        }
    }

    func testDict() throws {
        let encoder = SQLEncoder()
        try Dict().encode(to: encoder)

        let setters = try encoder.generateSetters()
        XCTAssertEqual(setters.count, 1)
        if setters.count == 1 {
            switch setters["embedded"]!.sqlValue {
            case .string(let string):
                AssertJSONEqual(string, [
                    "string": "my string",
                    "int": 1,
                    "double": 2.3,
                    "bool": true,
                    "point": [
                        "x": 4,
                        "y": 5,
                    ],
                    "time": "6:7:8",
                    "date": "1970-01-01T00:00:00.0Z",
                    "data": "SGVsbG8=",
                ])
            default:
                XCTFail()
            }
        }
    }

    func testArray() throws {
        let encoder = SQLEncoder()
        try Arr().encode(to: encoder)

        let setters = try encoder.generateSetters()
        XCTAssertEqual(setters.count, 1)
        if setters.count == 1 {
            switch setters["embedded"]!.sqlValue {
            case .string(let string):
                AssertJSONEqual(string, [
                    [
                        "string": "my string",
                        "int": 1,
                        "double": 2.3,
                        "bool": true,
                        "point": [
                            "x": 4,
                            "y": 5,
                        ],
                        "time": "6:7:8",
                        "date": "1970-01-01T00:00:00.0Z",
                        "data": "SGVsbG8=",
                    ],
                    [
                        "string": "my string",
                        "int": 1,
                        "double": 2.3,
                        "bool": true,
                        "point": [
                            "x": 4,
                            "y": 5,
                        ],
                        "time": "6:7:8",
                        "date": "1970-01-01T00:00:00.0Z",
                        "data": "SGVsbG8=",
                    ],
                ])
            default:
                XCTFail()
            }
        }
    }
}
