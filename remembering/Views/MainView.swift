//
//  MainView.swift
//  remembering
//
//  Created by 배주웅 on 1/11/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Label {
                        Text("21일째 연속 학습중!")
                    } icon: {
                        Image(systemName: "flame.fill").foregroundColor(.red)
                    }
                }
                
                NavigationLink(destination: WordQuizView()) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("오늘의 레슨")
                    }
                }
                
                Button("나의 단어", systemImage: "person.fill") {}.buttonStyle(.bordered)
            }
            .navigationBarTitle("Rememberin: Japanese Word")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("", systemImage: "gear") {}
                }
            }
        }
    }
}

#Preview {
    MainView()
}
