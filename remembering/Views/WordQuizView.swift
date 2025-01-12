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
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader {
                    geometry in VStack {
                        VStack {
                            Text("大使館")
                                .padding(10)
                                .fontWeight(.bold)
                                .font(.largeTitle)
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(30)

                        if self.displayAnswerCard {
                            VStack {
                                Text("대사관")
                                    .font(.largeTitle)
                                    .padding(.bottom, 8)
                                HStack {
                                    Image(systemName: "speaker.wave.2.fill")
                                    Text("taishikan")
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
                    self.displayAnswerCard = !self.displayAnswerCard
                }

                VStack {
                    Spacer()
                    if self.displayAnswerCard {
                        WordCardAction(
                            retryMinute: "<1분", difficultyMinute: "<6분", correctMinute: "<10분", easyMinute: "3일"
                        )
                    } else {
                        WordQuizStatus(
                            longTermCount: self.termCount,
                            shortTermCount: self.termCount,
                            newWordCount: self.termCount
                        )
                    }
                }

            }.navigationBarTitle("오늘의 단어 퀴즈", displayMode: .inline)
        }
    }
}

#Preview {
    WordQuizView()
}
