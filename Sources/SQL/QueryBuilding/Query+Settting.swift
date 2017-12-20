//
//  Query+Settting.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/6/17.
//

public protocol SettableQuery: TableQuery {
    /// Intended for internal use
    ///
    /// Use 'filter' and 'filtered' methods instead
    var setters: [String:QueryComponent] {get set}
}

extension SettableQuery {
    public func setting(_ setters: [QualifiedField:ParameterConvertible?]) -> Self {
        var newSetters = self.setters
        for (key, value) in setters {
            newSetters["\"\(key.name)\""] = value?.sqlParameter ?? .null
        }
        var new = self
        new.setters = newSetters
        return new
    }
}
