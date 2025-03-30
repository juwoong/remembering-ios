//
//  SuperMemoScheduler.swift
//  remembering
//
//  Created by 배주웅 on 1/24/25.
//
import Foundation


class SuperMemoScheduler {
    static let availablePriorities = [0, 1, 2, 3, 4]
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
            ease: self.cfg.defaultEase,
            data: data
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
    
    private func loadExponentialCards(_ now: Date) -> [LearningCard] {
        let formatDate = dateToSQLString(now)
        let query = "SELECT * FROM cards WHERE next_review <= '\(formatDate)' AND phase = '\(LearningPhase.EXPONENTIAL.rawValue)'"
        
        let queryCardResult = SQLiteDatabase.read(sql: query, to: LearningCard.self)
        var result: [LearningCard] = []
        for cardResult in queryCardResult {
            let query = "SELECT * FROM datas WHERE id = \(cardResult.dataId)"
            let dataResult = SQLiteDatabase.read(sql: query, to: ContentDataModel.self)
            
            if !dataResult.isEmpty {
                result.append(
                    cardResult.update {
                        $0.data = dataResult[0]
                    }
                )
            }
        }
        
        return result
    }
    
    private func createNewSchedule(_ now: Date) throws -> LearningSchedule {
        let startDate = startOfDay(now)
        let obj = LearningSchedule(date: startDate, status: ScheduleState.NOT_STARTED, created: [], learning: [], exponentials: [], done: [])
        
        let id: Int? = SQLiteDatabase.create(obj)
        if id == nil {
            throw LearningScheduleError.failedToCreateLearningSchedule(obj.toString())
        }
        
        return obj.update { $0.id = id! }
    }
    
    private func loadCardById(_ id: Int) throws -> LearningCard {
        let query = "SELECT * FROM cards WHERE id = \(id)"
        
        let result = SQLiteDatabase.read(sql: query, to: LearningCard.self)
        if result.isEmpty {
            throw LearningCardError.failedToCreateLearningCard("No card found with id \(id)")
        }
        
        return result[0]
    }
    
    private func loadCardsByIdList(_ idList: [Int]) -> [LearningCard] {
        let queryId = idList.map { String($0) }.joined(separator: ", ")
        let query = "SELECT * FROM cards WHERE id IN (\(queryId))"
        
        let result = SQLiteDatabase.read(sql: query, to: LearningCard.self)
        let dataQueryId = result.map { String($0.dataId) }.joined(separator: ", ")
        let dataList = SQLiteDatabase.read(sql: "SELECT * FROM datas WHERE id IN (\(dataQueryId))", to: ContentDataModel.self)
        let dataDict = Dictionary(uniqueKeysWithValues: dataList.map { ($0.id, $0)})
                
        var results: [LearningCard] = []
        for card in result {
            if let data = dataDict[card.dataId] {
                results.append(
                    card.update {
                        $0.data = data
                    }
                )
            }
        }
        
        return results
    }
    
    private func fillScheduleInstance(_ schedule: LearningSchedule) -> LearningSchedule {
        let createdCards = loadCardsByIdList(schedule.created)
        let learningCards = loadCardsByIdList(schedule.learning)
        let reviewedCard = loadCardsByIdList(schedule.exponentials)
        
        return schedule.update {
            $0.createdCard = createdCards
            $0.learningCard = learningCards
            $0.exponentialCard = reviewedCard
        }
    }
    
    func getSchedule(_ now: Date) throws -> LearningSchedule {
        let openSchedules = SQLiteDatabase
            .read(sql: "SELECT * FROM schedules WHERE status IN (\(ScheduleState.NOT_STARTED.rawValue), \(ScheduleState.IN_PROGRESS.rawValue))", to: LearningSchedule.self)
        
        let today = startOfDay(now)
        if !openSchedules.isEmpty {
            print("schedule exists")
            let updatedSchedule = fillScheduleInstance(openSchedules[0]).update {
                $0.date = today
            }
            
            if !SQLiteDatabase.update(updatedSchedule) {
                throw LearningScheduleError.failedToUpdateLearningSchedule(updatedSchedule.toString())
            }
            
            return updatedSchedule
        }
        
        let todaySchedule = SQLiteDatabase.read(sql: "SELECT * FROM schedules WHERE date='\(dateToSQLString(today))'", to: LearningSchedule.self)
        
        if !todaySchedule.isEmpty {
            return todaySchedule[0]
        }
        
        print("schedule not exists.. creating new one")
        let schedule = try! self.createNewSchedule(now)
        // FIXME: handle data finished Here
        let newData = self.loadUnusedData(10)
        
        var newCards: [LearningCard] = []
        for data in newData {
            if let card = try? self.createNewCard(data) {
                newCards.append(card)
                
                let _ = SQLiteDatabase.update(data.update {
                    $0.isGenerated = true
                })
            }
        }
        
        let exponentials = self.loadExponentialCards(now)
        let resultSchedule = schedule.update {
            $0.created = newCards.map { $0.id }
            $0.exponentials = exponentials.map { $0.id }
            $0.createdCard = newCards
            $0.exponentialCard = exponentials
            $0.status = .IN_PROGRESS
        }
        
        if !SQLiteDatabase.update(resultSchedule) {
            throw LearningScheduleError.failedToUpdateLearningSchedule(resultSchedule.toString())
        }
        
        return resultSchedule
    }
}
