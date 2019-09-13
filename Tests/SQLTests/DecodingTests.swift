//
//  File.swift
//  
//
//  Created by Andrew J Wagner on 9/13/19.
//

import XCTest
@testable import SQL

class DecodingTests: XCTestCase {
    func testLeafsOnly() throws {
        let row = RawDataRow(columns: [
            "int": "101",
            "bool": "true",
            "float": "102.3",
            "double": "104.5",
            "string": "my other string",
            "int8": "106",
            "int16": "107",
            "int32": "108",
            "int64": "109",
            "uint": "110",
            "uint8": "111",
            "uint16": "112",
            "uint32": "113",
            "uint64": "114",
            "point": "(115,116)",
            "time": "7:8:9",
            "date": "1970-01-01T00:00:00.0Z",
            "data": "Hello World".data(using: .utf8)!,
        ])
        let decoder = SQLDecoder(row: row, forTableNamed: nil)
        let value = try LeafOnly(from: decoder)
        XCTAssertEqual(value.int, 101)
        XCTAssertEqual(value.bool, true)
        XCTAssertEqual(value.float, 102.3)
        XCTAssertEqual(value.double, 104.5)
        XCTAssertEqual(value.string, "my other string")
        XCTAssertEqual(value.int8, 106)
        XCTAssertEqual(value.int16, 107)
        XCTAssertEqual(value.int32, 108)
        XCTAssertEqual(value.int64, 109)
        XCTAssertEqual(value.uint, 110)
        XCTAssertEqual(value.uint8, 111)
        XCTAssertEqual(value.uint16, 112)
        XCTAssertEqual(value.uint32, 113)
        XCTAssertEqual(value.uint64, 114)
        XCTAssertEqual(value.point.x, 115)
        XCTAssertEqual(value.point.y, 116)
        XCTAssertEqual(value.time.hour, 7)
        XCTAssertEqual(value.time.minute, 8)
        XCTAssertEqual(value.time.second, 9)
        XCTAssertEqual(value.date.iso8601DateTime, "1970-01-01T00:00:00.0Z")
        XCTAssertEqual(String(data: value.data, encoding: .utf8), "Hello World")
    }

    func testSingleValueContainers() throws {
        let row = RawDataRow(columns: [
            "int": "101",
            "bool": "true",
            "float": "102.3",
            "double": "104.5",
            "string": "my other string",
            "int8": "106",
            "int16": "107",
            "int32": "108",
            "int64": "109",
            "uint": "110",
            "uint8": "111",
            "uint16": "112",
            "uint32": "113",
            "uint64": "114",
            "point": "(115,116)",
            "time": "7:8:9",
            "date": "1970-01-01T00:00:00.0Z",
            "data": "Hello World".data(using: .utf8)!,
        ])
        let decoder = SQLDecoder(row: row, forTableNamed: nil)
        let value = try SingleValueContainers(from: decoder)
        XCTAssertEqual(value.int.value, 101)
        XCTAssertEqual(value.bool.value, true)
        XCTAssertEqual(value.float.value, 102.3)
        XCTAssertEqual(value.double.value, 104.5)
        XCTAssertEqual(value.string.value, "my other string")
        XCTAssertEqual(value.int8.value, 106)
        XCTAssertEqual(value.int16.value, 107)
        XCTAssertEqual(value.int32.value, 108)
        XCTAssertEqual(value.int64.value, 109)
        XCTAssertEqual(value.uint.value, 110)
        XCTAssertEqual(value.uint8.value, 111)
        XCTAssertEqual(value.uint16.value, 112)
        XCTAssertEqual(value.uint32.value, 113)
        XCTAssertEqual(value.uint64.value, 114)
        XCTAssertEqual(value.point.value.x, 115)
        XCTAssertEqual(value.point.value.y, 116)
        XCTAssertEqual(value.time.value.hour, 7)
        XCTAssertEqual(value.time.value.minute, 8)
        XCTAssertEqual(value.time.value.second, 9)
        XCTAssertEqual(value.date.value.iso8601DateTime, "1970-01-01T00:00:00.0Z")
        XCTAssertEqual(String(data: value.data.value, encoding: .utf8), "Hello World")
    }

    func testOptionals() throws {
        let row = RawDataRow(columns: [
            "string1": "is there changed",
        ])
        let decoder = SQLDecoder(row: row, forTableNamed: nil)
        let value = try Optionals(from: decoder)
        XCTAssertEqual(value.string1, "is there changed")
        XCTAssertNil(value.string2)
    }

    func testDict() throws {
        let row = RawDataRow(columns: [
            "embedded": """
                {
                    "string": "my other string",
                    "int": 101,
                    "double": 102.3,
                    "bool": true,
                    "point": {
                        "x": 104,
                        "y": 105,
                    },
                    "time": "7:8:9",
                    "date": "1970-01-01T00:00:00.0Z",
                    "data": "\("Hello World".data(using: .utf8)!.base64)"
                }
                """,
        ])
        let decoder = SQLDecoder(row: row, forTableNamed: nil)
        let value = try Dict(from: decoder)
        XCTAssertEqual(value.embedded.string, "my other string")
        XCTAssertEqual(value.embedded.int, 101)
        XCTAssertEqual(value.embedded.double, 102.3)
        XCTAssertEqual(value.embedded.bool, true)
        XCTAssertEqual(value.embedded.point.x, 104)
        XCTAssertEqual(value.embedded.point.y, 105)
        XCTAssertEqual(value.embedded.time.hour, 7)
        XCTAssertEqual(value.embedded.time.minute, 8)
        XCTAssertEqual(value.embedded.time.second, 9)
        XCTAssertEqual(value.embedded.date.iso8601DateTime, "1970-01-01T00:00:00.0Z")
        XCTAssertEqual(String(data: value.embedded.data, encoding: .utf8), "Hello World")
    }

    func testArray() throws {
        let row = RawDataRow(columns: [
            "embedded": """
                [
                    {
                        "string": "my other string",
                        "int": 101,
                        "double": 102.3,
                        "bool": true,
                        "point": {
                            "x": 104,
                            "y": 105,
                        },
                        "time": "7:8:9",
                        "date": "1970-01-01T00:00:00.0Z",
                        "data": "\("Hello World".data(using: .utf8)!.base64)"
                    },
                    {
                        "string": "my other string",
                        "int": 101,
                        "double": 102.3,
                        "bool": true,
                        "point": {
                            "x": 104,
                            "y": 105,
                        },
                        "time": "7:8:9",
                        "date": "1970-01-01T00:00:00.0Z",
                        "data": "\("Hello World".data(using: .utf8)!.base64)"
                    }
                ]
                """,
        ])
        let decoder = SQLDecoder(row: row, forTableNamed: nil)
        let value = try Arr(from: decoder)
        XCTAssertEqual(value.embedded[0].string, "my other string")
        XCTAssertEqual(value.embedded[0].int, 101)
        XCTAssertEqual(value.embedded[0].double, 102.3)
        XCTAssertEqual(value.embedded[0].bool, true)
        XCTAssertEqual(value.embedded[0].point.x, 104)
        XCTAssertEqual(value.embedded[0].point.y, 105)
        XCTAssertEqual(value.embedded[0].time.hour, 7)
        XCTAssertEqual(value.embedded[0].time.minute, 8)
        XCTAssertEqual(value.embedded[0].time.second, 9)
        XCTAssertEqual(value.embedded[0].date.iso8601DateTime, "1970-01-01T00:00:00.0Z")
        XCTAssertEqual(String(data: value.embedded[0].data, encoding: .utf8), "Hello World")

        XCTAssertEqual(value.embedded[1].string, "my other string")
        XCTAssertEqual(value.embedded[1].int, 101)
        XCTAssertEqual(value.embedded[1].double, 102.3)
        XCTAssertEqual(value.embedded[1].bool, true)
        XCTAssertEqual(value.embedded[1].point.x, 104)
        XCTAssertEqual(value.embedded[1].point.y, 105)
        XCTAssertEqual(value.embedded[1].time.hour, 7)
        XCTAssertEqual(value.embedded[1].time.minute, 8)
        XCTAssertEqual(value.embedded[1].time.second, 9)
        XCTAssertEqual(value.embedded[1].date.iso8601DateTime, "1970-01-01T00:00:00.0Z")
        XCTAssertEqual(String(data: value.embedded[1].data, encoding: .utf8), "Hello World")
    }
}
