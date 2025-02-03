//
//  WordQuizViewModel.swift
//  remembering
//
//  Created by 배주웅 on 2/2/25.
//
import SwiftUI

protocol WordQuizViewMdoelProtocol: ObservableObject {
    var displayAnswerCard: Bool { get set }
    var isBookmarked: Bool { get set }
    var studyFinished: Bool { get set }
    var currentCard: LearningCard { get set }
}


class WordQuizViewModel: WordQuizViewMdoelProtocol {
    
    @Published var displayAnswerCard = false
    @Published var isBookmarked: Bool = false
    @Published var studyFinished: Bool
    @Published var currentCard: LearningCard
    
    let cfg: SuperMemo2Config
    let scheduler: SuperMemoScheduler
    let ctx: ScheduleContext
    
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
}
