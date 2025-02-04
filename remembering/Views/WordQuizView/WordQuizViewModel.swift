//
//  WordQuizViewModel.swift
//  remembering
//
//  Created by 배주웅 on 2/2/25.
//
import SwiftUI

protocol WordQuizViewModelProtocol: ObservableObject {
    var displayAnswerCard: Bool { get set }
    var isBookmarked: Bool { get set }
    var studyFinished: Bool { get set }
    var currentCard: LearningCard { get set }
    
    func onCardTap()
    func onActionSelected(action: LearningChoice)
    func speakPronounciation()
    func getChoices() -> SuperMemoChoiceResult
    func getStatus() -> (longTermCount: Int, shortTermCount: Int, newWordCount: Int)
    func checkFinished()
    func setStartDate(_ date: Date)
    func setEndDate(_ date: Date) -> Double
}


class WordQuizViewModel: WordQuizViewModelProtocol {
    @Published var displayAnswerCard = false
    @Published var isBookmarked: Bool = false
    @Published var studyFinished: Bool
    @Published var currentCard: LearningCard
    
    let cfg: SuperMemo2Config
    let scheduler: SuperMemoScheduler
    let ctx: ScheduleContext
    
    var startDate: Date?
    var endDate: Date?
    
    init() {
        let cfg = getDefaultSuperMemo2Config()
        self.cfg = cfg
        
        let scheduler = SuperMemoScheduler(cfg: cfg)
        self.scheduler = scheduler
        
        // find schedule
        let schedule = try! scheduler.getSchedule(Date())
        let studyFinished = (schedule.status == .FINISHED)
        
        let ctx = ScheduleContext(schedule: schedule, supermemo: SuperMemo2(cfg: cfg))
        self.ctx = ctx
        
        let currentCard = ctx.next()
        self.currentCard = currentCard
        
        self.studyFinished = studyFinished || currentCard.isEmpty
    }
    
    func onCardTap() {
        if !displayAnswerCard {
            displayAnswerCard = true
        }
    }
    
    func onActionSelected(action: LearningChoice) {
        let nextCard = ctx.apply(currentCard, action)
        
        if !nextCard.isEmpty {
            currentCard = nextCard
            displayAnswerCard = false
        } else {
            studyFinished = true
            ctx.finishSchedule()
        }
    }
    
    func speakPronounciation() {
        if let pronounciation = currentCard.data?.question {
            speakJapanese(pronounciation)
        }
    }
    
    func getChoices() -> SuperMemoChoiceResult {
        return ctx.getCardChoices(currentCard)
    }
    
    func getStatus() -> (longTermCount: Int, shortTermCount: Int, newWordCount: Int) {
        return ctx.getRemainCardStatus()
    }
    
    func checkFinished() {
        if self.ctx.isFinished() {
            self.studyFinished = true
        }
    }
    
    func setStartDate(_ date: Date) {
        self.startDate = date
    }
    
    func setEndDate(_ date: Date) -> Double {
        self.endDate = date
        
        if let start = self.startDate {
            if let end = self.endDate {
                let res = end.timeIntervalSince(start)
                print("Time elapsed: " + String(format: "%.1f", res) + "sec")
                
                return res
            }
        }
        print("Time elapsed: 0.0 sec")
        
        return 0.0
    }
}


class MockWordQuizViewModel: WordQuizViewModelProtocol {
    @Published var displayAnswerCard = false
    @Published var isBookmarked: Bool = false
    @Published var studyFinished: Bool
    @Published var currentCard: LearningCard
    
    init() {
        studyFinished = false
        currentCard = LearningCard(dataId: 1, phase: .NEW, interval: 100, ease: 0.0)
        
        currentCard = currentCard.update {
            $0.data = ContentDataModel(id: 1, question: "大好き", description: DescriptionJSON(pronunciation: "daisuki", meaning: "좋아해"), priority: 1, isGenerated: true)
        }
    }
    
    func onCardTap() {
        if !displayAnswerCard {
            displayAnswerCard = true
        }
    }
    
    func onActionSelected(action: LearningChoice) {
        displayAnswerCard = false
    }
    
    func speakPronounciation() {
        if let pronounciation = currentCard.data?.question {
            speakJapanese(pronounciation)
        }
    }
    
    func getChoices() -> SuperMemoChoiceResult {
        return SuperMemoChoiceResult(retry: "<1m", difficult: "<10m", correct: "1d", easy: "4d")
    }
    
    func getStatus() -> (longTermCount: Int, shortTermCount: Int, newWordCount: Int) {
        return (
            longTermCount: 10,
            shortTermCount: 20,
            newWordCount: 30
        )
    }
    
    func checkFinished() {
        studyFinished = false
    }
    
    func setStartDate(_ date: Date) {
    }
    
    func setEndDate(_ date: Date) -> Double {
        return 0.0
    }
}
