//
//  WordQuizView.swift
//  remembering
//
//  Created by 배주웅 on 1/12/25.
//
import SwiftUI

struct WordQuizView: View {
    
    @State var termCount = 0
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("大使館")
                        .padding(10)
                }.frame(
                    maxWidth: .infinity
                    
                )
                .background(Color.gray.opacity(0.2))
                .cornerRadius(30)
                
                VStack {
                    Text("?")
                        .padding(10)
                }.frame(
                    maxWidth: .infinity
                    
                )
                .background(Color.gray.opacity(0.2))
                .cornerRadius(30)
                
                Button("테스트용 버튼이에요") {
                    self.termCount += 1
                }
            
                WordQuizStatus(
                    longTermCount: self.termCount,
                    shortTermCount: self.termCount,
                    newWordCount: self.termCount
                )
            }.navigationBarTitle("오늘의 단어 퀴즈", displayMode: .inline)
        }
    }
}


#Preview {
    WordQuizView()
}
