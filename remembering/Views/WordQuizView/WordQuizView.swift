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
                        VStack(spacing: 20) {
                            // 질문 카드
                            VStack {
                                Text(viewModel.currentCard.data?.question ?? "ERROR")
                                    .padding(16)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 32))
                                    .foregroundColor(.primary)
                            }
                            .cardStyle(
                                phase: viewModel.currentCard.phase,
                                width: geometry.size.width * 0.9,
                                height: geometry.size.height * 0.4
                            )
                            
                            // 답변 카드
                            if viewModel.displayAnswerCard {
                                ZStack {
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Image(systemName: viewModel.isBookmarked ? "star.fill" : "star")
                                                .foregroundColor(viewModel.isBookmarked ? .orange : .gray.opacity(0.5))
                                                .font(.system(size: 24))
                                                .onTapGesture {
                                                    viewModel.isBookmarked.toggle()
                                                }
                                            Spacer()
                                        }.padding(.trailing, 20)
                                            .padding(.top, 20)
                                    }
                                    VStack {
                                        Text(viewModel.currentCard.data?.description.meaning ?? "ERROR")
                                            .font(.system(size: 32))
                                            .foregroundColor(.primary)
                                            .padding(.bottom, 12)
                                        HStack {
                                            Image(systemName: "speaker.wave.2.fill")
                                                .foregroundColor(.blue)
                                            Text(viewModel.currentCard.data?.description.pronunciation ?? "ERROR")
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(8)
                                        .background(CardStyle.getPhaseColor(viewModel.currentCard.phase).opacity(0.1))
                                        .cornerRadius(12)
                                        .onTapGesture {
                                            viewModel.speakPronounciation()
                                        }
                                    }
                                }
                                .cardStyle(
                                    phase: viewModel.currentCard.phase,
                                    width: geometry.size.width * 0.9,
                                    height: geometry.size.height * 0.4
                                )
                            } else {
                                // 물음표 카드
                                VStack {
                                    Text("?")
                                        .padding(10)
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.secondary)
                                }
                                .cardStyle(
                                    phase: viewModel.currentCard.phase,
                                    width: geometry.size.width * 0.9,
                                    height: geometry.size.height * 0.4
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal)
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
