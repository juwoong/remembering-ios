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
                HStack(spacing: 20) {
                    VStack(spacing: 10) {
                        ZStack {
                            // 도넛 그래프 배경
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                                .frame(width: 80, height: 80)
                            
                            // 진행률 표시 도넛
                            Circle()
                                .trim(from: 0, to: 0.65) // 65% 진행률 예시
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .frame(width: 80, height: 80)
                            
                            // 중앙 텍스트
                            VStack(spacing: 0) {
                                Text("65%")
                                    .font(.system(size: 16, weight: .bold))
                                Text("학습 완료")
                                    .font(.system(size: 10))
                            }
                        }
                        
                        // Text("전체 학습 진행률")
                        //     .font(.subheadline)
                        //     .foregroundColor(.secondary)
                    }
                    // 좌우 간격 조정
                    Spacer().frame(width: 4)
                    // 연속 학습 정보
                    VStack(spacing: 5) {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.red)
                            Text("21일")
                                .font(.system(size: 18, weight: .bold))
                        }
                        Text("연속 학습중")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)

                    // 학습 시작 정보
                    VStack(spacing: 5) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundColor(.blue)
                            Text("+ 30일")
                                .font(.system(size: 18, weight: .bold))
                        }
                        Text("학습 시작")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                }
                .padding(.vertical, 10)


                // NavigationLink(destination: WordQuizView(viewModel: WordQuizViewModel())) {
                Button {
                    // 액션
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                            .shadow(radius: 2)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("2025년 03월 17일 오늘의 레슨")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            Text("일본어 기초 단어 (II)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    .frame(height: 90)
                    .padding(.horizontal)
                }
                
                Button {
                    // 액션
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.1))
                            .shadow(radius: 2)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("나만의 학습 자료")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            Text("나의 단어장")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    .frame(height: 90)
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
