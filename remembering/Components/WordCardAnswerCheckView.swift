//
//  WordCardAnswerCheckComponent.swift
//  remembering
//
//  Created by 배주웅 on 2/4/25.
//
import SwiftUI

struct WordCardQuestionAnswerView: View {
    var body: some View {
        HStack(spacing: 12) {
            Spacer()

            Button("틀렸어요"){}.buttonStyle(.bordered).tint(.red)
            Spacer()

            Button("맞았어요"){}.buttonStyle(.bordered).tint(.green)
            Spacer()
        }
    }
}



#Preview {
    WordCardQuestionAnswerView()
}
