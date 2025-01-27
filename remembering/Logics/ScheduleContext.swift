//
//  ScheduleContext.swift
//  remembering
//
//  Created by 배주웅 on 1/26/25.
//
import Foundation

enum ListType: Int {
    case CREATED = 1
    case LEARNING = 2
    case EXPONENTIAL = 3
    case DONE = 4
}

struct ScheduleRemainCardResult {
    let longTermCount: Int
    let shortTermCount: Int
    let newWordCount: Int
}

class ScheduleContext {
    private var schedule: LearningSchedule
    private let logic: SuperMemo2
    private var lastFrom: ListType? = nil
    
    init(schedule: LearningSchedule, supermemo: SuperMemo2) {
        self.schedule = schedule
        self.logic = supermemo
    }
    
    func next() -> LearningCard? {
        if !self.schedule.created.isEmpty {
            self.lastFrom = ListType.CREATED
            return self.schedule.createdCard.first
        } else if !self.schedule.exponentials.isEmpty {
            self.lastFrom = ListType.EXPONENTIAL
            return self.schedule.exponentialCard.first
        } else if !self.schedule.learning.isEmpty {
            self.lastFrom = ListType.LEARNING
            return self.schedule.learingCard.first
        }
        
        return nil
    }
    
    private func moveCard(_ listFrom: ListType, _ idx: Int, _ listTo: ListType) {
        var targetId: Int? = nil
        var target: LearningCard? = nil
        
        if listFrom == ListType.CREATED {
            targetId = self.schedule.created.remove(at: idx)
            target = self.schedule.createdCard.remove(at: idx)
        } else if listFrom == ListType.EXPONENTIAL {
            targetId = self.schedule.exponentials.remove(at: idx)
            target = self.schedule.exponentialCard.remove(at: idx)
        } else if listFrom == ListType.LEARNING {
            targetId = self.schedule.learning.remove(at: idx)
            target = self.schedule.learingCard.remove(at: idx)
        }
        
        if targetId != nil {
            if listTo == ListType.CREATED {
                self.schedule.created.append(targetId!)
                self.schedule.createdCard.append(target!)
            } else if listTo == ListType.EXPONENTIAL {
                self.schedule.exponentials.append(targetId!)
                self.schedule.exponentialCard.append(target!)
            } else if listTo == ListType.LEARNING {
                self.schedule.learning.append(targetId!)
                self.schedule.learingCard.append(target!)
            } else if listTo == ListType.DONE {
                self.schedule.done.append(targetId!)
                self.schedule.doneCard.append(target!)
            }
        }
    }
    
    func getCardChoices(_ card: LearningCard) -> SuperMemoChoiceResult {
        print(card)
        let result =  self.logic.getExpectIntervals(card)
        
        print("expecetd", result)
        return result
    }
    
    func apply(_ card: LearningCard, _ choice: LearningChoice) -> LearningCard? {
        let result = self.logic.getCardNext(card, choice)
        
        var nextCard = card.update {
            $0.phase = result.phase
            $0.step = result.step ?? 0
            $0.ease = result.ease ?? 0.0
            $0.interval = result.interval ?? 0
            $0.leech = result.leech
        }
        
        if result.phase == LearningPhase.EXPONENTIAL {
            print("EXPONENTIAL", nextCard.interval, self.lastFrom?.rawValue ?? "N/A")
            
            let now = Date()
            nextCard = nextCard.update {
                $0.nextReview = addMinutes(now, nextCard.interval)
                $0.lastReview = now
            }
            
            self.moveCard(self.lastFrom!, 0, .DONE)
        } else if result.phase == LearningPhase.LEARN {
            self.moveCard(self.lastFrom!, 0, .LEARNING)
        } else if result.phase == LearningPhase.RELEARN {
            self.moveCard(self.lastFrom!, 0, .LEARNING)
        }
        
        let _ = SQLiteDatabase.update(nextCard)
        let _ = SQLiteDatabase.update(self.schedule)
        
        return self.next()
    }
    
    func getRemainCardStatus() -> ScheduleRemainCardResult {
        return ScheduleRemainCardResult(
            longTermCount: self.schedule.exponentials.count,
            shortTermCount: self.schedule.learning.count,
            newWordCount: self.schedule.created.count
        )
    }
    
    func finishSchedule() {
        self.schedule = schedule.update {
            $0.status = .FINISHED
        }
        
        // TODO: fix this to handle all things
        let _  = SQLiteDatabase.update(self.schedule)
    }
}
