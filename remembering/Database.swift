//
//  Database.swift
//  remembering
//
//  Created by 배주웅 on 1/15/25.
//
import Foundation
import SQLite3


func parseNullableDatetimeColumn(stmt: OpaquePointer?, index: Int) -> Date? {
    if stmt == nil {
        return nil
    }
    
    if sqlite3_column_type(stmt, Int32(index)) != SQLITE_NULL {
        if let cString = sqlite3_column_text(stmt, 0) {
            let dateString = String(cString: cString)
            print("Date: \(dateString)")
            
            // DateFormatter를 이용해 Date 타입으로 변환
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
    }
    
    return nil
}


class SQLiteDatabase {
    static let dbName: String = "content.db"
    
    static func getDatabasePath() -> String {
        let path = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent(dbName)
        
        return path.path
    }
    
    static func initialize() {
        let originPath = Bundle.main.path(forResource: "content", ofType: "db")
        let destPath = getDatabasePath()
        
        if !FileManager.default.fileExists(atPath: destPath) {
            do {
                try FileManager.default.copyItem(atPath: originPath!, toPath: destPath)
            } catch let error as NSError {
                print("error occurs during database initialization: \(error)")
            }
        }
    }
    
    static func read<T: SQLModel>(sql: String, to: T.Type) -> [T] {
        var database: OpaquePointer?
        let query = "SELECT * FROM datas LIMIT 10;"
        
        let dbPath = getDatabasePath()
        if sqlite3_open(dbPath, &database) != SQLITE_OK {
            print("error to open database")
            return []
        }
        
        var statement: OpaquePointer?
        if sqlite3_prepare(database, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database))
            print("Error to prepare statement: \(errmsg)")
            
            return []
        }
        
        var results: [T] = []
        while(sqlite3_step(statement) == SQLITE_ROW) {
            let result = createDTOInstance(to: to, pointer: statement)
            results.append(result)
        }
        
        return results
    }
}
