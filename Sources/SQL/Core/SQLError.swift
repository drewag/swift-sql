//
//  SQLError.swift
//  PostgreSQL
//
//  Created by Andrew J Wagner on 12/10/17.
//

import Foundation
import Swiftlier

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

extension SQLError: ReportableErrorConvertible, ErrorGenerating {
    public var reportableError: ReportableError {
        return self.error("performing SQL", because: self.description)
    }
}

extension SQLError: LocalizedError {
    public var errorDescription: String? {
        return self.description
    }
}
