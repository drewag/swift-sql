//
//  Row+Coding.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

import Foundation
import Swiftlier

extension Row {
    public func decode<T: TableStorable>(purpose: CodingPurpose, userInfo: [CodingUserInfoKey:Any] = [:]) throws -> T where T: Decodable {
        let decoder = RowDecoder(row: self, forTableNamed: T.tableName)
        decoder.userInfo = userInfo
        decoder.userInfo.location = .local
        decoder.userInfo.purpose = purpose
        return try T(from: decoder)
    }

    public func decodeRaw<D: Decodable>(purpose: CodingPurpose, userInfo: [CodingUserInfoKey:Any] = [:], tableName: String? = nil) throws -> D {
        let decoder = RowDecoder(row: self, forTableNamed: tableName)
        decoder.userInfo = userInfo
        decoder.userInfo.location = .local
        decoder.userInfo.purpose = purpose
        return try D(from: decoder)
    }
}
