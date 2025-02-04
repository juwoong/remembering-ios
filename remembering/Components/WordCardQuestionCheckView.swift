//
//  WordCardQuestionStatus.swift
//  remembering
//
//  Created by 배주웅 on 2/4/25.
//
import SwiftUI


struct WordCardQuestionCheckView: View {
    var body: some View {
        HStack(spacing: 12) {
            Spacer()

            Button("모르겠어요"){}.buttonStyle(.bordered).tint(.pink)
            Spacer()

            Button("알겠어요"){}.buttonStyle(.bordered).tint(.blue)
            Spacer()
        }
    }
}



#Preview {
    WordCardQuestionCheckView()
}
