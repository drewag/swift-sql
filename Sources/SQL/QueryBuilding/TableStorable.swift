//
//  Table.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/5/17.
//

public protocol TableStorable {
    associatedtype Fields: Field

    static var tableName: String {get}
}
