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
    @State var studyFinished: Bool = false
    var contents: [ContentDataModel] // TODO: change this to card lol
    
    init() {
        self.contents = SQLiteDatabase.read(sql: "SELECT * FROM datas LIMIT 20;", to: ContentDataModel.self)
    }
    
    var body: some View {
        NavigationView {
            if !self.studyFinished {
                ZStack {
                    GeometryReader { geometry in
                        VStack {
                            VStack {
                                Text(contents[index].question)
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
                                        Text(contents[index].description.meaning)
                                            .font(.largeTitle)
                                            .padding(.bottom, 8)
                                        HStack {
                                            Image(systemName: "speaker.wave.2.fill")
                                            Text(contents[index].description.pronunciation)
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
                        self.displayAnswerCard.toggle()
                        
                        // toggle한 이후기 때문에 false
                        if self.displayAnswerCard == false && self.index < self.contents.count - 1{
                            
                            self.index += 1
                        } else if self.index == self.contents.count - 1 {
                            self.studyFinished.toggle()
                        }
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
