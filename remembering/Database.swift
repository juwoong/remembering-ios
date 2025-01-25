//
//  Database.swift
//  remembering
//
//  Created by 배주웅 on 1/15/25.
//
import Foundation
import SQLite3


func parseNullableDatetimeColumn(stmt: OpaquePointer?, index: Int32) -> Date? {
    if stmt == nil {
        return nil
    }
    
    if sqlite3_column_type(stmt, index) != SQLITE_NULL {
        if let cString = sqlite3_column_text(stmt, index) {
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

func parseJSONLikeColumn<T: Decodable>(stmt: OpaquePointer?, index: Int32, to: T.Type) -> T? {
    if stmt == nil {
        return nil
    }
    
    if sqlite3_column_type(stmt, index) != SQLITE_NULL {
        if let cString = sqlite3_column_text(stmt, index) {
            let jsonString = String(cString: cString)
            
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    let result = try JSONDecoder().decode(to, from: jsonData)
                    
                    return result
                } catch {
                    print("Error during parse JSON: \(error)")
                }
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
    
    static func prepareDatabase() -> OpaquePointer? {
        var database: OpaquePointer?
        let dbPath = getDatabasePath()
        
        if sqlite3_open(dbPath, &database) != SQLITE_OK {
            print("error to open database")
            return nil
        }
        
        return database
    }
    
    static func read<T: SQLModel>(sql: String, to: T.Type) -> [T] {
        var database = SQLiteDatabase.prepareDatabase()
        let query = "SELECT * FROM datas LIMIT 10;"
        
        var statement: OpaquePointer?
        if sqlite3_prepare(database, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database))
            print("Error to prepare statement: \(errmsg)")
            
            return []
        }
        
        var results: [T] = []
        while(sqlite3_step(statement) == SQLITE_ROW) {
            let result = createDTOInstance(to: to, stmt: statement)
            results.append(result)
        }
        
        return results
    }
    
    static func create<T: WriteableSQLModel>(_ model: T) -> Int? {
        var database = SQLiteDatabase.prepareDatabase()
        let dbPath = getDatabasePath()
        
        if sqlite3_open(dbPath, &database) != SQLITE_OK {
            print("error to open database")
            return nil
        }
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(database, model.insertQuery(), -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database))
            print("Error to prepare statement: \(errmsg)")
            
            return nil
        }
        
        let lastRowId = Int(sqlite3_last_insert_rowid(database))
        return lastRowId
    }
    
    static func update<T: WriteableSQLModel>(_ model: T) -> Bool{
        var database = SQLiteDatabase.prepareDatabase()
        let dbPath = getDatabasePath()
        
        if sqlite3_open(dbPath, &database) != SQLITE_OK {
            print("error to open database")
            return false
        }
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(database, model.insertQuery(), -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database))
            print("Error to prepare statement: \(errmsg)")
            
            return false
        }
        
        return true
    }
}
