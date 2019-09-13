//
//  File.swift
//  
//
//  Created by Andrew J Wagner on 9/12/19.
//

import Swiftlier

public enum SQLEncodingError: Error, SwiftlierError {
    case invalidValueCombination
    case invalidRootValue

    public var title: String { "Failed to encode for SQL" }

    public var alertMessage: String {
        switch self {
        case .invalidValueCombination:
            return "Encoding a mixture of unkeyed, keyed, and/or regular values is not supported."
        case .invalidRootValue:
            return "The root value encoded must be keyed."
        }
    }

    public var details: String? {
        return nil
    }

    public var isInternal: Bool { true }

    public var backtrace: [String]? { nil }

    public var description: String {
        return "\(self.title): \(self.alertMessage)"
    }
}
