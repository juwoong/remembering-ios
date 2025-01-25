//
//  LearningSchedule.swift
//  remembering
//
//  Created by 배주웅 on 1/17/25.
//
import Foundation
import SQLite3


struct LearningSchedule: SQLModel {
    var id: Int = 0
    var date: Date
    var status: ScheduleState
    var created: [Int]
    var learning: [Int]
    var exponentials: [Int]
    var done: [Int]
    
    static func parse(stmt: OpaquePointer?) -> Self {
        let id = Int(sqlite3_column_int(stmt, 0))
        let date = parseNullableDatetimeColumn(stmt: stmt, index: 1)!
        let rawStatus = Int(sqlite3_column_int(stmt, 2))
        let created = parseJSONLikeColumn(stmt: stmt, index: 3, to: [Int].self)
        let learning = parseJSONLikeColumn(stmt: stmt, index: 4, to: [Int].self)
        let exponential = parseJSONLikeColumn(stmt: stmt, index: 5, to: [Int].self)
        let done = parseJSONLikeColumn(stmt: stmt, index: 6, to: [Int].self)
        
    
        return LearningSchedule(
            id: id,
            date: date,
            status: ScheduleState(rawValue: rawStatus)!,
            created: created ?? [],
            learning: learning ?? [],
            exponentials: exponential ?? [],
            done: done ?? []
        )
    }
    
    func toString() -> String {
        return "LearningSchedule(id: \(id), date: \(date), status: \(status), created: \(created), learning: \(learning), exponentials: \(exponentials), done: \(done))"
    }
}

extension LearningSchedule: WriteableSQLModel {
    func insertQuery() -> String {
        let formattedDate = "'\(dateToSQLString(self.date))'"
        let formattedCreated = try! jsonEncode(self.created)
        let formattedLearning = try! jsonEncode(self.learning)
        let formattedReviewed = try! jsonEncode(self.exponentials)
        let formattedDone = try! jsonEncode(self.done)
        
        return """
        INSERT INTO schedules(date, status, created, learning, reviewed, done)
        VALUES(\(formattedDate), \(self.status.rawValue), '\(formattedCreated)', '\(formattedLearning)', '\(formattedReviewed)', '\(formattedDone)')
        """
    }
    
    func updateQuery() -> String {
        let formattedDate = "'\(dateToSQLString(self.date))'"
        let formattedCreated = try! jsonEncode(self.created)
        let formattedLearning = try! jsonEncode(self.learning)
        let formattedReviewed = try! jsonEncode(self.exponentials)
        let formattedDone = try! jsonEncode(self.done)
        
        return """
        UPDATE schedules
        SET
            date = \(formattedDate),
            status = \(self.status.rawValue),
            created = '\(formattedCreated)',
            learning = '\(formattedLearning)',
            reviewed = '\(formattedReviewed)',
            done = '\(formattedDone)'
        WHERE id = \(self.id)
        """
    }
}
