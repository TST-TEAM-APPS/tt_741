

import SwiftUI

struct MarathonView: View {
    @EnvironmentObject var environment: GameEnvironment
    @Environment(\.dismiss) var dismiss
    @State private var selectedDifficulty: Difficulty = .analyst
    @State private var isStarted = false
    @State private var showRules = false
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            if !isStarted {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            CustomIconView(name: "chevron", size: 24)
                                .foregroundColor(Palette.text)
                                .rotationEffect(.degrees(90))
                        }
                        
                        Spacer()
                        
                        Text("Marathon Mode")
                            .font(Typography.title3)
                            .foregroundColor(Palette.text)
                        
                        Spacer()
                        
                        Color.clear.frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    ScrollView {
                        VStack(spacing: 32) {
                            // Marathon Icon
                            ZStack {
                                Circle()
                                    .fill(Palette.error.opacity(0.15))
                                    .frame(width: 120, height: 120)
                                
                                CustomIconView(name: "flame", size: 60)
                                    .foregroundColor(Palette.error)
                            }
                            .padding(.top, 40)
                            
                            // Description
                            VStack(spacing: 12) {
                                Text("Endless Challenge")
                                    .font(Typography.title2)
                                    .foregroundColor(Palette.text)
                                
                                Text("Solve puzzles continuously until you make a mistake. Each correct answer increases your streak!")
                                    .font(Typography.callout)
                                    .foregroundColor(Palette.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }
                            
                            // Best Score
                            VStack(spacing: 8) {
                                Text("Your Best")
                                    .font(Typography.caption)
                                    .foregroundColor(Palette.textSecondary)
                                    .textCase(.uppercase)
                                    .tracking(1)
                                
                                Text("\(environment.userProgress.bestMarathonScore)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(Palette.error)
                            }
                            .padding(.vertical, 24)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Palette.cardBackground)
                            )
                            .padding(.horizontal, 24)
                            
                            // Difficulty Selection
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Select Difficulty")
                                    .font(Typography.headline)
                                    .foregroundColor(Palette.text)
                                    .padding(.horizontal, 24)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                            MarathonDifficultyChip(
                                                difficulty: difficulty,
                                                isSelected: selectedDifficulty == difficulty
                                            )
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    selectedDifficulty = difficulty
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }
                            
                            // Rules Button
                            Button(action: { showRules = true }) {
                                HStack {
                                    CustomIconView(name: "info", size: 20)
                                    Text("Marathon Rules")
                                        .font(Typography.callout)
                                }
                                .foregroundColor(Palette.accent)
                                .padding(.vertical, 12)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                    
                    // Start Button
                    Button(action: {
                        environment.startNewPuzzle(difficulty: selectedDifficulty, mode: .marathon)
                        isStarted = true
                    }) {
                        HStack {
                            Text("Start Marathon")
                                .font(Typography.headline)
                            
                            CustomIconView(name: "play", size: 20)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Palette.error)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            } else {
                PuzzleView()
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showRules) {
            MarathonRulesView()
        }
    }
}

struct MarathonDifficultyChip: View {
    let difficulty: Difficulty
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? difficulty.color : difficulty.color.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Text("\(difficulty.characterCount.lowerBound)")
                    .font(Typography.title3)
                    .foregroundColor(isSelected ? .white : difficulty.color)
                    .fontWeight(.bold)
            }
            
            Text(difficulty.rawValue)
                .font(Typography.caption)
                .foregroundColor(isSelected ? Palette.text : Palette.textSecondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Palette.cardBackground : Color.clear)
                .shadow(color: Color.black.opacity(isSelected ? 0.05 : 0), radius: 10, x: 0, y: 4)
        )
    }
}

struct MarathonRulesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        RuleItemView(
                            icon: "target",
                            title: "Objective",
                            description: "Solve as many puzzles as you can in a row without making a mistake."
                        )
                        
                        RuleItemView(
                            icon: "flame",
                            title: "Streak System",
                            description: "Each correct answer increases your streak counter. Your best streak is saved."
                        )
                        
                        RuleItemView(
                            icon: "xmark",
                            title: "Game Over",
                            description: "One wrong answer ends your marathon run immediately."
                        )
                        
                        RuleItemView(
                            icon: "chart",
                            title: "Difficulty",
                            description: "Choose your difficulty at the start. Higher difficulties give more complex puzzles."
                        )
                        
                        RuleItemView(
                            icon: "trophy",
                            title: "Challenge",
                            description: "Test your logical thinking under pressure and beat your personal best!"
                        )
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Marathon Rules")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Palette.accent)
                }
            }
        }
    }
}

struct RuleItemView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Palette.accent.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                CustomIconView(name: icon, size: 24)
                    .foregroundColor(Palette.accent)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(Typography.headline)
                    .foregroundColor(Palette.text)
                
                Text(description)
                    .font(Typography.callout)
                    .foregroundColor(Palette.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
