//
//  File.swift
//  
//
//  Created by Andrew J Wagner on 9/13/19.
//

import Foundation

public protocol DataConvertible {
    var data: Data {get}
}

extension Data: DataConvertible {
    public var data: Data { self }
}

extension String: DataConvertible {
    public var data: Data { self.data(using: .utf8)! }
}

public class RawDataRow: Row<RawSelectQuery> {
    let rawColumns: [String:Data]

    public init(columns: [String:DataConvertible]) {
        self.rawColumns = columns.mapValues({ $0.data })
    }

    public override func data(forColumnNamed name: String) throws -> Data? {
        return self.rawColumns[name]
    }

    public override var columns: [String] {
        return Array(self.rawColumns.keys)
    }
}
