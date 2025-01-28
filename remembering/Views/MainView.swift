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
                
//                NavigationLink(destination: EmptyView()) {
//                    VStack {
//                        HStack {
//                            Image(systemName: "calendar").foregroundStyle(.white)
//                            Text("오늘의 레슨").foregroundStyle(.white)
//                        }.padding(10)
//                    }.background(Color(hex: "#3B6790"), in: RoundedRectangle(cornerRadius: 25))
//                }
         
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
