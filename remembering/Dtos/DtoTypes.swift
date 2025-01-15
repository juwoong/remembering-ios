//
//  Types.swift
//  remembering
//
//  Created by 배주웅 on 1/15/25.
//
import SQLite3

protocol SQLParsable {
    static func parse(pointer: OpaquePointer?) -> Self
    func toString() -> String
}

func createDTOInstance<T: SQLParsable>(to: T.Type, pointer: OpaquePointer?) -> T {
    return to.parse(pointer: pointer)
}
