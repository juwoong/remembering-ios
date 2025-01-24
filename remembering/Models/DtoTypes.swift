//
//  Types.swift
//  remembering
//
//  Created by 배주웅 on 1/15/25.
//
import SQLite3

protocol SQLModel {
    static func parse(stmt: OpaquePointer?) -> Self
    func toString() -> String
}

protocol WriteableSQLModel: SQLModel {
    func insertQuery() -> String
    func updateQuery() -> String
}

func createDTOInstance<T: SQLModel>(to: T.Type, stmt: OpaquePointer?) -> T {
    return to.parse(stmt: stmt)
}
