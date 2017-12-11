//
//  Connection.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/10/17.
//

public protocol Connection {
    var isConnected: Bool {get}
    func connect() throws
    func disconnect()

    func error(_ message: String?) -> SQLError

    func run(statement: String, arguments: [Value]) throws
    func run<Query: AnyQuery>(statement: String, arguments: [Value]) throws -> Result<Query>
}
