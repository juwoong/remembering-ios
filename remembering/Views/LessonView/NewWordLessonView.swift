import SwiftUI

struct NewWordLessonView: View {
    @State private var currentIndex = 0
    @State private var isBookmarked = false
    
    let word: String
    let translation: String
    let pronunciation: String
    
    var body: some View {
        VStack {
            Text("오늘의 단어")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            
            // 카드 뷰
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(radius: 4)
                .overlay(
                    VStack(spacing: 12) {
                        Text(word)
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(translation)
                            .font(.system(size: 20))
                        
                        HStack {
                            Button(action: {
                                // 발음 재생 기능 추가 예정
                            }) {
                                Image(systemName: "speaker.wave.2")
                            }
                            Text(pronunciation)
                                .font(.system(size: 16))
                        }
                    }
                )
                .frame(height: 280)
                .frame(maxHeight: .infinity, alignment: .center)

            
            
            // 프로그레스 바와 텍스트를 붙이기 위한 VStack
            VStack(spacing: 8) {
                Text("오늘의 새로운 단어 (\(currentIndex + 1) / 10)")
                    .font(.caption)
                    .padding(.bottom, 2)
                ProgressView(value: Double(currentIndex + 1), total: 10)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                
  
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

#Preview {
    NewWordLessonView(
        word: "大好き",
        translation: "좋아해",
        pronunciation: "daisuki"
    )
} 
