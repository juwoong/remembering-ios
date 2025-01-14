//
//  Database.swift
//  remembering
//
//  Created by 배주웅 on 1/15/25.
//
import Foundation
import SQLite3


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
    
    static func read() {
        var database: OpaquePointer?
        let query = "SELECT * FROM datas LIMIT 10;"
        
        let dbPath = getDatabasePath()
        if sqlite3_open(dbPath, &database) != SQLITE_OK {
            print("error to open database")
            return
        }
        
        var statement: OpaquePointer?
        if sqlite3_prepare(database, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database))
            print("Error to prepare statement: \(errmsg)")
        }
        /*
         CREATE TABLE IF NOT EXISTS datas (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             question TEXT NOT NULL,
             description TEXT NOT NULL,
             priority INTEGER NOT NULL,
             is_generated BOOLEAN NOT NULL
         );

         */
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(statement, 0))
            let question = String(cString: sqlite3_column_text(statement, 1))
            let description = String(cString: sqlite3_column_text(statement, 2))
            let priority = Int(sqlite3_column_int(statement, 3))
            let is_generated = Int(sqlite3_column_int(statement, 0)) == 1
            
            print("Data(\(id), \(question), \(description), \(priority), \(is_generated))")
        }
    }
}
