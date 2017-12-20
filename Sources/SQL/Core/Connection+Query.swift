//
//  Connection+Query.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/5/17.
//

extension Connection {
    public func executeIgnoringResult(_ query: AnyQuery) throws {
        try self.run(query.statement, arguments: query.arguments)
    }

    public func execute(any query: AnyQuery) throws {
        let _ = try self.run(query.statement, arguments: query.arguments)
    }

    public func execute<Query: RowReturningQuery>(_ query: Query) throws -> Result<Query> {
        return try self.execute(query)
    }

    public func begin() throws {
        try self.execute(sql: "BEGIN")
    }

    public func commit() throws {
        try self.execute(sql: "COMMIT")
    }

    public func rollback() throws {
        try self.execute(sql: "ROLLBACK")
    }

    public func transaction<Output>(handler: () throws -> (Output)) throws -> Output {
        try self.begin()

        do {
            let result = try handler()
            try self.commit()
            return result
        }
        catch {
            try self.rollback()
            throw error
        }
    }
}

private extension Connection {
    func execute(sql: String) throws {
        let _ = try self.executeIgnoringResult(RawEmptyQuery(sql: sql))
    }

    func replaceParametersWithNumbers(in statement: String) -> String {
        var output: String = ""
        var varCount = 1
        for component in statement.components(separatedBy: "%@") {
            if !output.isEmpty {
                output += "$\(varCount)"
                varCount += 1
            }

            output += component
        }
        return output
    }
}
