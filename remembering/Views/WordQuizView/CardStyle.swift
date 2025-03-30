import SwiftUI

struct CardStyle: ViewModifier {
    let phase: LearningPhase
    let width: CGFloat
    let height: CGFloat
    
    static func getPhaseColor(_ phase: LearningPhase) -> Color {
        switch phase {
        case .NEW: return .blue
        case .EXPONENTIAL: return .green
        case .LEARN: return .orange
        case .RELEARN: return .red
        }
    }
    
    private var phaseColor: Color {
        CardStyle.getPhaseColor(phase)
    }
    
    private var phaseText: String {
        switch phase {
        case .NEW: return "새 단어"
        case .EXPONENTIAL: return "장기 학습 단어"
        case .LEARN: return "단기 학습 단어"
        case .RELEARN: return "재학습 단어"
        }
    }
    
    func body(content: Content) -> some View {
        VStack {
            Text(phaseText)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(phaseColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(phaseColor.opacity(0.1))
                .cornerRadius(8)
            
            content
        }
        .frame(width: width, height: height)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: phaseColor.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(phaseColor.opacity(0.2), lineWidth: 1.5)
        )
    }
}

extension View {
    func cardStyle(phase: LearningPhase, width: CGFloat, height: CGFloat) -> some View {
        modifier(CardStyle(phase: phase, width: width, height: height))
    }
} 