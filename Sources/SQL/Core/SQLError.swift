//
//  SQLError.swift
//  PostgreSQL
//
//  Created by Andrew J Wagner on 12/10/17.
//

import Foundation
import Swiftlier

public struct SQLError: SwiftlierError {
    public let title: String = "Error Performing SQL"
    public let alertMessage: String
    public let details: String?
    public let isInternal: Bool = true
    public let backtrace: [String]?


    public var description: String {
        return "Error Performing SQL: \(self.alertMessage)"
    }

    public init(message: String, moreInformation: String? = nil, backtrace: [String]? = Thread.callStackSymbols) {
        self.alertMessage = message
        self.details = moreInformation
        self.backtrace = backtrace
    }
}
