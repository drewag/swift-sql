//
//  Point.swift
//  CHTTPParser
//
//  Created by Andrew J Wagner on 6/8/19.
//

public struct Point: Codable {
    public let x: Float
    public let y: Float

    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }

    public init(latitude: Float, longitude: Float) {
        self.x = longitude
        self.y = latitude
    }
}

extension Point: ValueConvertible {
    public var sqlValue: Value {
        return .point(x: self.x, y: self.y)
    }
}
