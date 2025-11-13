import SwiftUI

struct DifficultySelectionView: View {
    @EnvironmentObject var environment: GameEnvironment
    @Environment(\.dismiss) var dismiss
    @State private var selectedDifficulty: Difficulty?
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        CustomIconView(name: "chevron", size: 24)
                            .foregroundColor(Palette.text)
                            .rotationEffect(.degrees(90))
                    }
                    
                    Spacer()
                    
                    Text("Select Difficulty")
                        .font(Typography.title3)
                        .foregroundColor(Palette.text)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 24, height: 24)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            DifficultyCardView(difficulty: difficulty)
                                .onTapGesture {
                                    selectedDifficulty = difficulty
                                    environment.startNewPuzzle(difficulty: difficulty, mode: .classic)
                                }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(item: $selectedDifficulty) { _ in
            PuzzleView()
        }
    }
}

struct DifficultyCardView: View {
    let difficulty: Difficulty
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(difficulty.rawValue)
                        .font(Typography.title2)
                        .foregroundColor(Palette.text)
                    
                    Text("\(difficulty.characterCount.lowerBound)-\(difficulty.characterCount.upperBound) characters")
                        .font(Typography.caption)
                        .foregroundColor(Palette.textSecondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(difficulty.color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Text("\(difficulty.characterCount.lowerBound)")
                        .font(Typography.title3)
                        .foregroundColor(difficulty.color)
                        .fontWeight(.bold)
                }
            }
            
            // Feature indicators
            HStack(spacing: 12) {
                ForEach(difficultyFeatures(for: difficulty), id: \.self) { feature in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(difficulty.color)
                            .frame(width: 4, height: 4)
                        
                        Text(feature)
                            .font(Typography.caption)
                            .foregroundColor(Palette.textSecondary)
                    }
                }
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Palette.border.opacity(0.3))
                        .frame(height: 4)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(difficulty.color)
                        .frame(width: geometry.size.width * difficultyProgress(for: difficulty), height: 4)
                }
            }
            .frame(height: 4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Palette.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(difficulty.color.opacity(0.3), lineWidth: 2)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private func difficultyFeatures(for difficulty: Difficulty) -> [String] {
        switch difficulty {
        case .novice:
            return ["Simple", "Direct"]
        case .analyst:
            return ["Implications", "References"]
        case .expert:
            return ["Complex", "Nested"]
        case .sage:
            return ["Advanced", "Conditional"]
        }
    }
    
    private func difficultyProgress(for difficulty: Difficulty) -> CGFloat {
        switch difficulty {
        case .novice: return 0.25
        case .analyst: return 0.5
        case .expert: return 0.75
        case .sage: return 1.0
        }
    }
}
