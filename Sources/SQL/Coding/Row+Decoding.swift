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
        let decoder = self.decoder(purpose: purpose, userInfo: userInfo, tableName: T.tableName)
        return try T(from: decoder)
    }

    public func decodeRaw<D: Decodable>(purpose: CodingPurpose, userInfo: [CodingUserInfoKey:Any] = [:], tableName: String? = nil) throws -> D {
        let decoder = self.decoder(purpose: purpose, userInfo: userInfo, tableName: tableName)
        return try D(from: decoder)
    }

    public func decoder<T: TableStorable>(purpose: CodingPurpose, userInfo: [CodingUserInfoKey:Any] = [:], for type: T.Type) -> Decoder {
        return self.decoder(purpose: purpose, userInfo: userInfo, tableName: T.tableName)
    }

    public func decoder(purpose: CodingPurpose, userInfo: [CodingUserInfoKey:Any] = [:], tableName: String? = nil) -> Decoder {
        let decoder = SQLDecoder(row: self, forTableNamed: tableName)
        decoder.userInfo = userInfo
        decoder.userInfo.location = .local
        decoder.userInfo.purpose = purpose
        return decoder
    }
}
