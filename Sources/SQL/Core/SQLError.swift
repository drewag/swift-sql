//
//  SQLError.swift
//  PostgreSQL
//
//  Created by Andrew J Wagner on 12/10/17.
//

public struct SQLError: Error, CustomStringConvertible {
    public let message: String
    public let moreInformation: String?

    public var description: String {
        return self.message
    }

    public init(message: String, moreInformation: String? = nil) {
        self.message = message
        self.moreInformation = moreInformation
    }
}
