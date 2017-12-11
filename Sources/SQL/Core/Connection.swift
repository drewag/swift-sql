//
//  Connection.swift
//  SQL
//
//  Created by Andrew J Wagner on 12/10/17.
//

protocol Connection {
    var isConnected: Bool {get}
    func connect() throws
    func disconnect()
}
