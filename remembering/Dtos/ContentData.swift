//
//  ContentData.swift
//  remembering
//
//  Created by 배주웅 on 1/15/25.
//
import SQLite3
import Foundation

struct DescriptionJSON: Codable {
    let pronunciation: String
    let meaning: String
    
    func toString() -> String {
        return "Descrption(pronunciation: \(pronunciation), meaning: \(meaning))"
    }
}

struct ContentDataDto: SQLParsable {
    let id: Int
    let question: String
    let description: DescriptionJSON
    let priority: Int
    let isGenerated: Bool
    
    static func parse(pointer: OpaquePointer?) -> Self {
        let id = Int(sqlite3_column_int(pointer, 0))
        let question = String(cString: sqlite3_column_text(pointer, 1))
        let _description = String(cString: sqlite3_column_text(pointer, 2))
        let priority = Int(sqlite3_column_int(pointer, 3))
        let isGenerated = Int(sqlite3_column_int(pointer, 4)) == 1
        
        let jsonDecoder = JSONDecoder()
        let description = try! jsonDecoder.decode(DescriptionJSON.self, from: Data(_description.utf8))
        
        return Self(id: id, question: question, description: description, priority: priority, isGenerated: isGenerated)
    }
    
    func toString() -> String {
        return "ContentDataDto(\(id), \(question), \(description.toString()), \(priority), \(isGenerated))"
    }
}
