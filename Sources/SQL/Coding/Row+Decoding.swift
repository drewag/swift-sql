//
//  Row+Coding.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

import Foundation
import Swiftlier

extension Row {
    public func decode<D: Decodable>(purpose: CodingPurpose, userInfo: [CodingUserInfoKey:Any] = [:]) throws -> D {
        let decoder = RowDecoder(row: self)
        decoder.userInfo = userInfo
        decoder.userInfo.location = .local
        decoder.userInfo.purpose = purpose
        return try D(from: decoder)
    }
}
