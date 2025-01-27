//
//  LearningCard.swift
//  remembering
//
//  Created by 배주웅 on 1/16/25.
//
import Foundation
import SQLite3


enum LearningCardError: Error {
    case failedToCreateLearningCard(String)
    case failedToUpdateLearningCard(String)
    case learningCardNotFound(String)
}


struct LearningCard: SQLModel {
    var id: Int = 0
    var dataId: Int
    var phase: LearningPhase
    var interval: Int
    var ease: Double
    var step: Int = 0
    var leech: Int = 0
    var lastReview: Date? = nil
    var nextReview: Date? = nil
    var data: ContentDataModel? = nil
    
    static func parse(stmt: OpaquePointer?) -> Self {
        let id = Int(sqlite3_column_int(stmt, 0))
        let dataId = Int(sqlite3_column_int(stmt, 1))
        let rawPhase = Int(sqlite3_column_int(stmt, 2))
        let interval = Int(sqlite3_column_int(stmt, 3))
        let ease = sqlite3_column_double(stmt, 4)
        let step = Int(sqlite3_column_int(stmt, 5))
        let leech = Int(sqlite3_column_int(stmt, 6))
        let lastReview = parseNullableDatetimeColumn(stmt: stmt, index: 7)
        let nextReview = parseNullableDatetimeColumn(stmt: stmt, index: 8)
        
        return LearningCard(
            id: id,
            dataId: dataId,
            phase: LearningPhase(rawValue: rawPhase)!,
            interval: interval,
            ease: ease,
            step: step,
            leech: leech,
            lastReview: lastReview,
            nextReview: nextReview
        )
    }
    
    func toString() -> String {
        return "LearningCard(id: \(id), dataId: \(dataId), interval: \(interval), ease: \(ease), phase: \(phase))"
    }
    
    func update(update: (inout Self) -> Void) -> Self {
        var copy = self
        update(&copy)
        return copy
    }
}

extension LearningCard: WriteableSQLModel {
    func insertQuery() -> String {
        let formattedLastReview = self.lastReview == nil ? "NULL" : "'\(dateToSQLString(self.lastReview!))'"
        let formattedNextReview = self.nextReview == nil ? "NULL" : "'\(dateToSQLString(self.nextReview!))'"
        
        return "INSERT INTO cards(data_id, phase, interval, ease, step, leech, last_review, next_review) VALUES(\(self.dataId), \(self.phase.rawValue), \(self.interval), \(self.ease), \(self.step), \(self.leech), \(formattedLastReview), \(formattedNextReview))"
    }
    
    func updateQuery() -> String {
        let formattedLastReview = self.lastReview == nil ? "NULL" : "'\(dateToSQLString(self.lastReview!))'"
        let formattedNextReview = self.nextReview == nil ? "NULL" : "'\(dateToSQLString(self.nextReview!))'"
        
        return """
        UPDATE cards
        SET
            data_id = \(self.dataId),
            phase = \(self.phase.rawValue),
            interval = \(self.interval),
            ease = \(self.ease),
            step = \(self.step),
            leech = \(self.leech),
            last_review = \(formattedLastReview),
            next_review = \(formattedNextReview)
        WHERE id = \(self.id);
        """
    }
}
