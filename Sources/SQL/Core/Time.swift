//
//  Time.swift
//  CHTTPParser
//
//  Created by Andrew Wagner on 6/11/19.
//

import Foundation

public struct Time {
    public let hour: Int // in 24 hour time
    public let minute: Int
    public let second: Int

    public init(hour: Int, minute: Int = 0, second: Int = 0) {
        self.hour = hour
        self.minute = minute
        self.second = second
    }

    public init(_ string: String) throws {
        var normalized = string.replacingOccurrences(of: " ", with: "").lowercased()
        enum Mode {
            case am, pm, military
        }
        let mode: Mode
        if normalized.hasSuffix("pm") {
            mode = .pm
            let endIndex = normalized.index(normalized.endIndex, offsetBy: -2)
            normalized = String(normalized[..<endIndex])
        }
        else if normalized.hasSuffix("am") {
            mode = .am
            let endIndex = normalized.index(normalized.endIndex, offsetBy: -2)
            normalized = String(normalized[..<endIndex])
        }
        else {
            mode = .military
        }

        let hour: Int
        let minute: Int
        let second: Int
        let components = normalized.components(separatedBy: ":")
        switch components.count {
        case 2:
            // hours and minutes
            guard let parsedHour = Int(components[0]) else { throw SQLError(message: "'\(string)' is not a valid time" ) }
            guard let parsedMinute = Int(components[1]) else { throw SQLError(message: "'\(string)' is not a valid time" ) }
            hour = parsedHour
            minute = parsedMinute
            second = 0
        case 3:
            // hours, minutes, and seconds
            guard let parsedHour = Int(components[0]) else { throw SQLError(message: "'\(string)' is not a valid time" ) }
            guard let parsedMinute = Int(components[1]) else { throw SQLError(message: "'\(string)' is not a valid time" ) }
            guard let parsedSecond = Int(components[2]) else { throw SQLError(message: "'\(string)' is not a valid time" ) }
            hour = parsedHour
            minute = parsedMinute
            second = parsedSecond
        default:
            throw SQLError(message: "'\(string)' is not a valid time" )
        }

        guard minute >= 0 && minute < 60 else {
            throw SQLError(message: "'\(string)' is not a valid time" )
        }

        guard second >= 0 && second < 60 else {
            throw SQLError(message: "'\(string)' is not a valid time" )
        }

        switch mode {
        case .am:
            guard hour > 0 && hour < 13 else {
                throw SQLError(message: "'\(string)' is not a valid time" )
            }
            self.hour = hour % 12
            self.minute = minute
            self.second = second
        case .pm:
            guard hour > 0 && hour < 13 else {
                throw SQLError(message: "'\(string)' is not a valid time" )
            }
            self.hour = (hour % 12) + 12
            self.minute = minute
            self.second = second
        case .military:
            guard hour >= 0 && hour < 24 else {
                throw SQLError(message: "'\(string)' is not a valid time" )
            }
            self.hour = hour
            self.minute = minute
            self.second = second
        }
    }
}

extension Time: CustomStringConvertible {
    public var description: String {
        let hourString: String
        let amPm: String
        switch self.hour {
        case 0:
            hourString = "12"
            amPm = "am"
        case 1...11:
            hourString = "\(hour)"
            amPm = "am"
        case 12:
            hourString = "12"
            amPm = "pm"
        case 12...23:
            hourString = "\(hour - 12)"
            amPm = "pm"
        default:
            hourString = "\(hour)"
            amPm = "pm"
        }
        let minuteString: String
        switch self.minute {
        case 0...9:
            minuteString = "0\(minute)"
        default:
            minuteString = "\(minute)"
        }

        switch self.second {
        case 0:
            return "\(hourString):\(minuteString)\(amPm)"
        case 1...9:
            return "\(hourString):\(minuteString):0\(second)\(amPm)"
        default:
            return "\(hourString):\(minuteString):\(second)\(amPm)"
        }
    }
}

extension Time: ValueConvertible {
    public var sqlValue: Value {
        return .time(hour: self.hour, minute: self.minute, second: self.second)
    }
}

extension Time: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}
