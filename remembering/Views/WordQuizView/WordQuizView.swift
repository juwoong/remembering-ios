//
//  WordQuizView.swift
//  remembering
//
//  Created by 배주웅 on 1/12/25.
//
import SwiftUI

struct WordQuizView<ViewModel: WordQuizViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    
    // 외부에서 주입할 수 있도록 이니셜라이저 추가
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        viewModel.setStartDate(Date())
    }
    
    var body: some View {
        NavigationView {
            if !viewModel.studyFinished {
                ZStack {
                    GeometryReader { geometry in
                        VStack {
                            VStack {
                                Text(viewModel.currentCard.data?.question ?? "ERROR")
                                    .padding(10)
                                    .fontWeight(.bold)
                                    .font(.largeTitle)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height / 2)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(30)
                            
                            if viewModel.displayAnswerCard {
                                ZStack{
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Image(
                                                systemName: viewModel.isBookmarked ? "star.fill" : "star"
                                            ).foregroundColor(viewModel.isBookmarked ? Color.orange : Color.black
                                            ).onTapGesture {
                                                viewModel.isBookmarked.toggle()
                                            }
                                            Spacer()
                                        }.padding(.trailing, 16)
                                            .padding(.top, 16)
                                    }
                                    VStack {
                                        Text(viewModel.currentCard.data?.description.meaning ?? "ERROR")
                                            .font(.largeTitle)
                                            .padding(.bottom, 8)
                                        HStack {
                                            Image(systemName: "speaker.wave.2.fill")
                                            Text(viewModel.currentCard.data?.description.pronunciation ?? "ERROR")
                                        }
                                        .onTapGesture {
                                            viewModel.speakPronounciation()
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
                        if viewModel.displayAnswerCard == false {
                            viewModel.displayAnswerCard.toggle()
                            viewModel.setStartDate(Date())
                        }
                    }
                    
                    VStack {
                        Spacer()
                        if viewModel.displayAnswerCard {
                            let choices = viewModel.getChoices()
                            
                            WordCardAction(
                                retryMinute: choices.retry, difficultyMinute: choices.difficult, correctMinute: choices.correct, easyMinute: choices.easy,
                                onButtonSelected: { action in
                                    viewModel.onActionSelected(action: action)
                                    viewModel.setEndDate(Date())
                                }
                            )
                        } else {
                            let status = viewModel.getStatus()
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
        }.onAppear {
            viewModel.checkFinished()
        }
    }
}


#Preview {
    WordQuizView(viewModel: MockWordQuizViewModel())
}
