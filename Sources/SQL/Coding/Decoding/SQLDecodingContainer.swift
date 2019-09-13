//
//  File.swift
//  
//
//  Created by Andrew J Wagner on 9/13/19.
//

import Foundation

protocol SQLDecodingContainer {}

extension SQLDecodingContainer {
    func point(from data: Data) -> Point? {
        guard let string = String(data: data, encoding: .utf8)
            , string.hasPrefix("(")
            , string.hasSuffix(")")
            else
        {
            return nil
        }

        let startIndex = string.index(after: string.startIndex)
        let endIndex = string.index(before: string.endIndex)
        let withoutParens = string[startIndex ..< endIndex]

        let components = withoutParens.components(separatedBy: ",")
        guard components.count == 2 else {
            return nil
        }

        guard let x = Float(components[0]), let y = Float(components[1]) else {
            return nil
        }

        return Point(x: x, y: y)
    }
}
