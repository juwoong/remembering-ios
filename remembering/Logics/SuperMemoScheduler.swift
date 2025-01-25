//
//  SuperMemoScheduler.swift
//  remembering
//
//  Created by 배주웅 on 1/24/25.
//

class SuperMemoScheduler {
    static let availablePriorities = [0, 1, 2]
    let cfg: SuperMemo2Config
    
    init(cfg: SuperMemo2Config) {
        self.cfg = cfg
    }
    
    
    private func loadUnusedData(_ limit: Int) -> [ContentDataModel] {
        var results: [ContentDataModel] = []
        
        for priority in SuperMemoScheduler.availablePriorities {
            let query = "SELECT * FROM datas WHERE is_generated = 0 AND priority = \(priority) ORDER BY RANDOM() LIMIT \(limit - results.count)"
            let queryResult = SQLiteDatabase.read(sql: query, to: ContentDataModel.self)
            
            results.append(contentsOf: queryResult)
        }
        
        return results
    }
    
    private func createNewCard(_ data: ContentDataModel) throws -> LearningCard  {
        var card = LearningCard(
            dataId: data.id,
            phase: LearningPhase.NEW,
            interval: 0,
            ease: self.cfg.defaultEase
        )
        
        let id: Int? = SQLiteDatabase.create(card)
        if id == nil {
            throw LearningCardError.failedToCreateLearningCard(card.toString())
        }
        card.id = id!
        
        let newData = ContentDataModel(id: data.id, question: data.question, description: data.description, priority: data.priority, isGenerated: true)
        if !SQLiteDatabase.update(newData) {
            throw ContentDataError.failedToUpdateContentDataError(newData.toString())
        }
        
        return card
    }
}
