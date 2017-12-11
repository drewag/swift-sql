//
//  Function.swift
//  SwiftServePostgres
//
//  Created by Andrew J Wagner on 12/5/17.
//

import Foundation

public enum Function: QueryComponent {
    case sum(QueryComponent)
    case boundedPseudoEncrypt24(value: QueryComponent, max: Int)
    case generateUUIDv4
    case custom(name: String, params: [QueryComponent])
    case toTimestamp(date: Date)

    public var sql: String {
        let name: String
        let params: [String]
        switch self {
        case .custom(let customName, let customParams):
            name = customName
            params = customParams.map({$0.sql})
        case .sum(let summing):
            name = "sum"
            params = [summing.sql]
        case .boundedPseudoEncrypt24(let value, _):
            name = "bounded_pseudo_encrypt"
            params = [value.sql, "%@"]
        case .generateUUIDv4:
            name = "uuid_generate_v4"
            params = []
        case .toTimestamp:
            name = "to_timestamp"
            params = ["%@", "'YYYY-MM-DD HH24:MI:SS.USZ'"]
        }
        let paramString = params.joined(separator: ",")
        return "\(name)(\(paramString))"
    }

    public var arguments: [Value] {
        switch self {
        case .sum(let sum):
            return sum.arguments
        case .boundedPseudoEncrypt24(let value, let max):
            return value.arguments + [.raw("\(max)")]
        case .generateUUIDv4:
            return []
        case .custom(_, let params):
            return params.flatMap({$0.arguments})
        case .toTimestamp(let date):
            return [date.sqlValue]
        }
    }

    static var creates: [RawEmptyQuery] {
        return [
            RawEmptyQuery(sql: """
                CREATE FUNCTION OR REPLACE pseudo_encrypt_24(VALUE int) returns int AS $$
                DECLARE
                l1 int;
                l2 int;
                r1 int;
                r2 int;
                i int:=0;
                BEGIN
                l1:= (VALUE >> 12) & (4096-1);
                r1:= VALUE & (4096-1);
                WHILE i < 3 LOOP
                l2 := r1;
                r2 := l1 # ((((1366 * r1 + 150889) % 714025) / 714025.0) * (4096-1))::int;
                l1 := l2;
                r1 := r2;
                i := i + 1;
                END LOOP;
                RETURN ((l1 << 12) + r1);
                END;
                $$ LANGUAGE plpgsql strict immutable;
                """
            ),
            RawEmptyQuery(sql: """
                CREATE OR REPLACE FUNCTION bounded_pseudo_encrypt(VALUE int, MAX int) returns int AS $$
                BEGIN
                LOOP
                VALUE := pseudo_encrypt_24(VALUE);
                EXIT WHEN VALUE <= MAX;
                END LOOP;
                RETURN VALUE;
                END
                $$ LANGUAGE plpgsql strict immutable;
                """
            ),
            RawEmptyQuery(sql: """
                CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";
                """
            )
        ]
    }
}

extension Function: ParameterConvertible {
    public var sqlParameter: Parameter {
        return .function(self)
    }
}
