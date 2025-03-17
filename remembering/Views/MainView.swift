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
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange.opacity(0.1))
                            .shadow(radius: 2)
                        
                        Label {
                            Text("21일째 연속 학습중!")
                                .fontWeight(.medium)
                        } icon: {
                            Image(systemName: "flame.fill").foregroundColor(.red)
                        }
                        .padding()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                NavigationLink(destination: WordQuizView(viewModel: WordQuizViewModel())) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                            .shadow(radius: 2)
                        
                        HStack {
                            Image(systemName: "calendar")
                            Text("오늘의 레슨")
                                .fontWeight(.medium)
                        }
                        .padding()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Button {
                    // 액션
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.1))
                            .shadow(radius: 2)
                        
                        HStack {
                            Image(systemName: "person.fill")
                            Text("나의 단어")
                                .fontWeight(.medium)
                        }
                        .padding()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
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
