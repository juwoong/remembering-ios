//
//  WordCardAction.swift
//  remembering
//
//  Created by 배주웅 on 1/12/25.
//

import SwiftUI

struct WordCardAction: View {
    
    var retryMinute: String
    var difficultyMinute: String
    var correctMinute: String
    var easyMinute: String
    
    var body: some View {
        HStack(spacing: 12) {
            Spacer()
            VStack {
                Text(self.retryMinute)
                Button("다시") {}.buttonStyle(.bordered).tint(.red)
            }
            Spacer()
            VStack {
                Text(self.difficultyMinute)
                Button("어려움") {}.buttonStyle(.bordered).tint(.orange)
            }
            Spacer()
            VStack {
                Text(self.correctMinute)
                Button("알맞음") {}.buttonStyle(.bordered).tint(.green)
            }
            Spacer()
            VStack {
                Text(self.easyMinute)
                Button("쉬움") {}.buttonStyle(.bordered).tint(.blue)
            }
            Spacer()
        }
    }
}


#Preview {
    WordCardAction(
        retryMinute: "<1분", difficultyMinute: "<6분", correctMinute: "<10분", easyMinute: "3일"
    )
}
