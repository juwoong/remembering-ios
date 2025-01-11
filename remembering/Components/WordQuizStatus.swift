//
//  WordQuizComponent.swift
//  remembering
//
//  Created by 배주웅 on 1/12/25.
//
import SwiftUI

struct WordQuizStatus: View {
    
    var longTermCount = 0
    var shortTermCount = 0
    var newWordCount = 0
    
    var body: some View {
        HStack(spacing: 32){
            VStack {
                Text("장기 복습")
                Text(String(self.longTermCount)).fontWeight(.bold)
            }.frame(minWidth: 40)
            VStack {
                Text("단기 복습")
                Text(String(self.shortTermCount)).fontWeight(.bold)
            }.frame(minWidth: 40)
            VStack {
                Text("신규 문제")
                Text(String(self.newWordCount)).fontWeight(.bold)
            }.frame(minWidth: 40)
        }
    }
}
