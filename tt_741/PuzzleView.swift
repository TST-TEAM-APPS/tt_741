import SwiftUI

struct PuzzleView: View {
    @EnvironmentObject var environment: GameEnvironment
    @Environment(\.dismiss) var dismiss
    @State private var animateCards = false
    @State private var showExplanation = false
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                PuzzleHeaderView(onBack: { dismiss() })
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                
                if let puzzle = environment.currentPuzzle {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Puzzle Info
                            PuzzleInfoView(puzzle: puzzle)
                                .padding(.horizontal, 24)
                                .padding(.top, 20)
                            
                            // Character Cards
                            VStack(spacing: 16) {
                                ForEach(Array(puzzle.characters.enumerated()), id: \.element.id) { index, character in
                                    if let statement = puzzle.statements.first(where: { $0.characterId == character.id }) {
                                        StatementCardView(
                                            character: character,
                                            statement: statement,
                                            selectedAnswer: environment.selectedAnswers[character.id.uuidString],
                                            onSelectTruth: {
                                                selectAnswer(for: character.id.uuidString, isTruth: true)
                                            },
                                            onSelectLie: {
                                                selectAnswer(for: character.id.uuidString, isTruth: false)
                                            }
                                        )
                                        .offset(y: animateCards ? 0 : 50)
                                        .opacity(animateCards ? 1 : 0)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateCards)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            // Submit Button
                            if !environment.selectedAnswers.isEmpty && !environment.showResult {
                                Button(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        environment.submitAnswer()
                                    }
                                }) {
                                    HStack {
                                        Text("Submit Answer")
                                            .font(Typography.headline)
                                        
                                        CustomIconView(name: "checkmark", size: 20)
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Palette.accent)
                                    )
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, 8)
                            }
                            
                            Spacer()
                                .frame(height: 40)
                        }
                    }
                } else {
                    Spacer()
                    
                    ProgressView()
                        .scaleEffect(1.5)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                animateCards = true
            }
        }
        .sheet(isPresented: $environment.showResult) {
            ResultView(onContinue: {
                environment.showResult = false
                if environment.marathonActive && environment.isCorrect {
                    environment.startNewPuzzle(difficulty: environment.currentPuzzle?.difficulty ?? .novice, mode: .marathon)
                    animateCards = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            animateCards = true
                        }
                    }
                } else if !environment.marathonActive && environment.isCorrect {
                    dismiss()
                } else {
                    environment.selectedAnswers.removeAll()
                }
            }, onExit: {
                environment.resetGame()
                dismiss()
            })
        }
    }
    
    private func selectAnswer(for characterId: String, isTruth: Bool) {
        guard !environment.showResult else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            environment.selectedAnswers[characterId] = isTruth
        }
    }
}

struct PuzzleHeaderView: View {
    @EnvironmentObject var environment: GameEnvironment
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                CustomIconView(name: "chevron", size: 24)
                    .foregroundColor(Palette.text)
                    .rotationEffect(.degrees(90))
            }
            
            Spacer()
            
            if environment.marathonActive {
                HStack(spacing: 8) {
                    CustomIconView(name: "flame", size: 20)
                        .foregroundColor(Palette.error)
                    
                    Text("\(environment.marathonScore)")
                        .font(Typography.title3)
                        .foregroundColor(Palette.text)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Palette.error.opacity(0.15))
                )
            }
            
            Spacer()
            
            Color.clear.frame(width: 24, height: 24)
        }
    }
}

struct PuzzleInfoView: View {
    let puzzle: Puzzle
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(puzzle.type.rawValue)
                        .font(Typography.title3)
                        .foregroundColor(Palette.text)
                    
                    Text(puzzle.difficulty.rawValue)
                        .font(Typography.caption)
                        .foregroundColor(puzzle.difficulty.color)
                        .textCase(.uppercase)
                        .tracking(1)
                }
                
                Spacer()
            }
            
            Text("Determine who tells the truth and who lies based on their statements.")
                .font(Typography.callout)
                .foregroundColor(Palette.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Palette.cardBackground)
        )
    }
}
