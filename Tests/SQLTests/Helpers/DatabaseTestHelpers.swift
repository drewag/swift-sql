//
//  File.swift
//  
//
//  Created by Andrew J Wagner on 9/13/19.
//

import Foundation
import XCTest
import SQL

func AssertEqual(_ lhs: ParameterConvertible?, _ rhs: Value, file: StaticString = #file, line: UInt = #line) {
    guard let lhs = lhs else {
        XCTFail(file: file, line: line)
        return
    }

    switch lhs.sqlParameter {
    case .value(let value):
        switch value ?? .null {
        case .bool(let lhs):
            switch rhs {
            case .bool(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .data(let lhs):
            switch rhs {
            case .data(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .double(let lhs):
            switch rhs {
            case .double(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .string(let lhs):
            switch rhs {
            case .string(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .float(let lhs):
            switch rhs {
            case .float(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .int(let lhs):
            switch rhs {
            case .int(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .int8(let lhs):
            switch rhs {
            case .int8(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .int16(let lhs):
            switch rhs {
            case .int16(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .int32(let lhs):
            switch rhs {
            case .int32(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .int64(let lhs):
            switch rhs {
            case .int64(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .uint(let lhs):
            switch rhs {
            case .uint(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .uint8(let lhs):
            switch rhs {
            case .uint8(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .uint16(let lhs):
            switch rhs {
            case .uint16(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .uint32(let lhs):
            switch rhs {
            case .uint32(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .uint64(let lhs):
            switch rhs {
            case .uint64(let rhs):
                XCTAssertEqual(lhs, rhs, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .null:
            switch rhs {
            case .null:
                break
            default:
                XCTFail(file: file, line: line)
            }
        case .point(let x, let y):
            switch rhs {
            case .point(let rX, let rY):
                XCTAssertEqual(x, rX, file: file, line: line)
                XCTAssertEqual(y, rY, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        case .time(let hour, let minute, let second):
            switch rhs {
            case .time(let rHour, let rMinute, let rSecond):
                XCTAssertEqual(hour, rHour, file: file, line: line)
                XCTAssertEqual(minute, rMinute, file: file, line: line)
                XCTAssertEqual(second, rSecond, file: file, line: line)
            default:
                XCTFail(file: file, line: line)
            }
        }
    case .null:
        switch rhs {
        case .null:
            break
        default:
            XCTFail(file: file, line: line)
        }
    default:
        XCTFail(file: file, line: line)
    }
}
