//
//  Table.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/5/17.
//

public protocol TableDecodable {
    static var tableName: String {get}
}

public protocol TableStorable: TableDecodable {
    associatedtype Fields: Field
}
