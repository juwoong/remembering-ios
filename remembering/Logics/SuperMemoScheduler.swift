//
//  SuperMemoScheduler.swift
//  remembering
//
//  Created by 배주웅 on 1/24/25.
//

class SuperMemoScheduler {
    static let availablePriorities = [0, 1, 2]
    
    
    private func loadUnusedData(_ limit: Int) -> [ContentDataModel] {
        var results: [ContentDataModel] = []
        
        for priority in SuperMemoScheduler.availablePriorities {
            let query = "SELECT * FROM datas WHERE is_generated = 0 AND priority = \(priority) ORDER BY RANDOM() LIMIT \(limit - results.count)"
            let queryResult = SQLiteDatabase.read(sql: query, to: ContentDataModel.self)
            
            results.append(contentsOf: queryResult)
        }
        
        return results
    }
}
