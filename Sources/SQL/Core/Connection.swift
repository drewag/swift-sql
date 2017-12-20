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

    func run(_ statement: String, arguments: [Value]) throws

    @discardableResult
    func execute<Query: AnyQuery>(_ query: Query) throws -> Result<Query>
}

extension Connection {
    public func run(_ statement: String) throws {
        try self.run(statement, arguments: [])
    }
}
