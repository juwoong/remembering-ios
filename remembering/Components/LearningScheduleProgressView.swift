//
//  LearningScheduleProgressComponents.swift
//  remembering
//
//  Created by 배주웅 on 2/4/25.
//
import SwiftUI

class LearningScheduleProgressViewModel: ObservableObject {
    @Published var progressAmount: Double = 0
}


struct LearingScheduleProgressView: View {
    @ObservedObject var viewModel: LearningScheduleProgressViewModel
    let totalCount: Double

    var body: some View {
        VStack {                                           //총값: 100
            ProgressView(String(format: "%.1f%%"), value: self.viewModel.progressAmount, total: self.totalCount)
                .padding()
        }
    }
}


#Preview {
    let viewModel = LearningScheduleProgressViewModel()
    LearingScheduleProgressView(viewModel: viewModel, totalCount: 100)
}
