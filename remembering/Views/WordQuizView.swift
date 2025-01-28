//
//  WordQuizView.swift
//  remembering
//
//  Created by 배주웅 on 1/12/25.
//
import SwiftUI

struct WordQuizView: View {

    @State var termCount = 21
    @State var displayAnswerCard = false
    @State var isBookmarked: Bool = false
    @State var index = 0
    @State var studyFinished: Bool
    @State var currentCard: LearningCard
    
    let cfg: SuperMemo2Config
    let scheduler: SuperMemoScheduler
    let ctx: ScheduleContext
    
    init() {
        let cfg = getDefaultSuperMemo2Config()
        let scheduler = SuperMemoScheduler(cfg: cfg)
        
        // Handle and show different
        let schedule = try! scheduler.getSchedule(Date())
        let studyFinished = (schedule.status == .FINISHED)

        let ctx = ScheduleContext(schedule: schedule, supermemo: SuperMemo2(cfg: cfg))
        let currentCard = ctx.next()

        // @State 초기값 설정
        _studyFinished = State(initialValue: studyFinished || currentCard.isEmpty)
        _currentCard = State(initialValue: currentCard)
        
        self.cfg = cfg
        self.scheduler = scheduler
        self.ctx = ctx
    }
    
    var body: some View {
        NavigationView {
            if !self.studyFinished {
                ZStack {
                    GeometryReader { geometry in
                        VStack {
                            VStack {
                                Text(currentCard.data?.question ?? "ERROR")
                                    .padding(10)
                                    .fontWeight(.bold)
                                    .font(.largeTitle)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height / 2)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(30)
                            
                            if self.displayAnswerCard {
                                ZStack{
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Image(
                                                systemName: self.isBookmarked ? "star.fill" : "star"
                                            ).foregroundColor(self.isBookmarked ? Color.orange : Color.black
                                            ).onTapGesture {
                                                self.isBookmarked.toggle()
                                            }
                                            Spacer()
                                        }.padding(.trailing, 16)
                                            .padding(.top, 16)
                                    }
                                    VStack {
                                        Text(currentCard.data?.description.meaning ?? "ERROR")
                                            .font(.largeTitle)
                                            .padding(.bottom, 8)
                                        HStack {
                                            Image(systemName: "speaker.wave.2.fill")
                                            Text(currentCard.data?.description.meaning ?? "ERROR")
                                        }
                                        .onTapGesture {
                                            if let meaning = currentCard.data?.description.meaning {
                                                speakJapanese(meaning)
                                            }
                                        }
                                    }
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height / 2)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(30)
                            } else {
                                VStack {
                                    Text("?")
                                        .padding(10)
                                        .font(.largeTitle)
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height / 2)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(30)
                            }
                        }
                    }
                    .padding(.bottom, 92)
                    .padding(.top, 20)
                    .onTapGesture {
                        if self.displayAnswerCard == false {
                            self.displayAnswerCard.toggle()
                        }
                    }
                    
                    VStack {
                        Spacer()
                        if self.displayAnswerCard {
                            let choices = self.ctx.getCardChoices(self.currentCard)
                            
                            WordCardAction(
                                retryMinute: choices.retry, difficultyMinute: choices.difficult, correctMinute: choices.correct, easyMinute: choices.easy,
                                onButtonSelected: { action in
                                    let nextCard = self.ctx.apply(self.currentCard, action)
                                    
                                    if !nextCard.isEmpty {
                                        self.currentCard = nextCard
                                        self.displayAnswerCard.toggle()
                                    } else {
                                        self.studyFinished.toggle()
                                        self.ctx.finishSchedule()
                                    }
                                }
                            )
                        } else {
                            let status = self.ctx.getRemainCardStatus()
                            WordQuizStatus(
                                longTermCount: status.longTermCount,
                                shortTermCount: status.shortTermCount,
                                newWordCount: status.newWordCount
                            )
                        }
                    }
                }
            } else {
                StudyFinishView()
            }
        }
    }
}


#Preview {
    WordQuizView()
}
