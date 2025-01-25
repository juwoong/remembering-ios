//
//  ContentData.swift
//  remembering
//
//  Created by 배주웅 on 1/15/25.
//
import SQLite3
import Foundation


enum ContentDataError: Error {
    case failedToCreateContentDataError(String)
    case failedToUpdateContentDataError(String)
}


struct DescriptionJSON: Codable {
    let pronunciation: String
    let meaning: String
    
    func toString() -> String {
        return "Descrption(pronunciation: \(pronunciation), meaning: \(meaning))"
    }
}

struct ContentDataModel: SQLModel {
    let id: Int
    let question: String
    let description: DescriptionJSON
    let priority: Int
    let isGenerated: Bool
    
    static func parse(stmt: OpaquePointer?) -> Self {
        let id = Int(sqlite3_column_int(stmt, 0))
        let question = String(cString: sqlite3_column_text(stmt, 1))
        let description = parseJSONLikeColumn(stmt: stmt , index: 2, to: DescriptionJSON.self)!
        let priority = Int(sqlite3_column_int(stmt, 3))
        let isGenerated = Int(sqlite3_column_int(stmt, 4)) == 1
        
        return Self(id: id, question: question, description: description, priority: priority, isGenerated: isGenerated)
    }
    
    func toString() -> String {
        return "ContentDataDto(\(id), \(question), \(description.toString()), \(priority), \(isGenerated))"
    }
}

extension ContentDataModel: WriteableSQLModel {
    func insertQuery() -> String {
        let formattedDescription = try! jsonEncode(self.description)
        let isGeneratedValue = self.isGenerated ? 1 : 0
        
        return """
        INSERT INTO datas (question, description, priority, is_generated)
        VALUES ('\(self.question)', '\(formattedDescription)', \(self.priority), \(isGeneratedValue))
        """
    }
    
    func updateQuery() -> String {
        let formattedDescription = try! jsonEncode(self.description)
        let isGeneratedValue = self.isGenerated ? 1 : 0
        
        return """
        UPDATE datas
        SET
            question = '\(self.question)',
            description = '\(formattedDescription)',
            priority = \(self.priority),
            is_generated = \(isGeneratedValue)
        WHERE id = \(self.id)
        """
    }
}
