//
//  JSONTestHelpers.swift
//  
//
//  Created by Andrew J Wagner on 9/12/19.
//

import Foundation
import XCTest
import Swiftlier

func AssertJSONEqual(_ json: String, _ raw: Any, file: StaticString = #file, line: UInt = #line) {
    guard let data = json.data(using: .utf8) else {
        XCTFail("Invalid JSON String: \(json)", file: file, line: line)
        return
    }

    AssertJSONEqual(data, raw, file: file, line: line)
}

func AssertJSONEqual(_ json: Data?, _ raw: Any, file: StaticString = #file, line: UInt = #line) {
    guard let lhsData = json else {
        XCTFail("Nil JSON data", file: file, line: line)
        return
    }

    guard let rhsData = try? JSONSerialization.data(withJSONObject: raw, options: []) else {
        XCTFail("Invalid JSON dict", file: file, line: line)
        return
    }

    AssertJSONEqual(lhsData, rhsData, file: file, line: line)
}

func AssertJSONEqual(_ lhsData: Data, _ rhsData: Data, file: StaticString = #file, line: UInt = #line) {
    guard let lhs = try? JSON(data: lhsData) else {
        if let string = String(data: lhsData, encoding: .utf8) {
            XCTFail("Invalid LHS JSON: \(string)", file: file, line: line)
        }
        else {
            XCTFail("Invalid RHS JSON", file: file, line: line)
        }
        return
    }

    guard let rhs = try? JSON(data: rhsData) else {
        if let string = String(data: rhsData, encoding: .utf8) {
            XCTFail("Invalid JSON: \(string)", file: file, line: line)
        }
        else {
            XCTFail("Invalid JSON", file: file, line: line)
        }
        return
    }

    XCTAssertEqual(lhs, rhs, file: file, line: line)
}
