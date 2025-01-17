//
//  LearningCard.swift
//  remembering
//
//  Created by 배주웅 on 1/16/25.
//
import Foundation
import SQLite3


struct LearningCard: SQLModel {
    var id: Int
    var dataId: Int
    var phase: LearningPhase
    var interval: Int
    var ease: Double
    var step: Int = 0
    var leech: Int = 0
    var lastReview: Date? = nil
    var nextReview: Date? = nil
    var data: ContentDataModel? = nil
    
    static func parse(pointer: OpaquePointer?) -> Self {
        let id = Int(sqlite3_column_int(pointer, 0))
        let dataId = Int(sqlite3_column_int(pointer, 1))
        let rawPhase = Int(sqlite3_column_int(pointer, 2))
        let interval = Int(sqlite3_column_int(pointer, 3))
        let ease = sqlite3_column_double(pointer, 4)
        let step = Int(sqlite3_column_int(pointer, 5))
        let leech = Int(sqlite3_column_int(pointer, 6))
        let lastReview = parseNullableDatetimeColumn(stmt: pointer, index: 7)
        let nextReview = parseNullableDatetimeColumn(stmt: pointer, index: 8)
        
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
    
}
