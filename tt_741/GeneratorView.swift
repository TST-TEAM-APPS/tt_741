


import SwiftUI

struct GeneratorView: View {
    @EnvironmentObject var environment: GameEnvironment
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDifficulty: Difficulty = .analyst
    @State private var selectedType: PuzzleType = .onlyOneTruth
    @State private var characterCount: Int = 3
    @State private var isGenerating = false
    @State private var generatedPuzzle: Puzzle?
    
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
                    
                    Text("AI Generator")
                        .font(Typography.title3)
                        .foregroundColor(Palette.text)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 24, height: 24)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Generator Icon
                        ZStack {
                            Circle()
                                .fill(Palette.success.opacity(0.15))
                                .frame(width: 100, height: 100)
                            
                            CustomIconView(name: "brain", size: 50)
                                .foregroundColor(Palette.success)
                        }
                        .padding(.top, 40)
                        
                        Text("Create Custom Puzzle")
                            .font(Typography.title2)
                            .foregroundColor(Palette.text)
                        
                        // Configuration
                        VStack(alignment: .leading, spacing: 24) {
                            // Difficulty
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Difficulty")
                                    .font(Typography.headline)
                                    .foregroundColor(Palette.text)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                            GeneratorOptionChip(
                                                title: difficulty.rawValue,
                                                color: difficulty.color,
                                                isSelected: selectedDifficulty == difficulty
                                            )
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    selectedDifficulty = difficulty
                                                    characterCount = difficulty.characterCount.lowerBound
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Puzzle Type
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Puzzle Type")
                                    .font(Typography.headline)
                                    .foregroundColor(Palette.text)
                                
                                VStack(spacing: 12) {
                                    ForEach(PuzzleType.allCases, id: \.self) { type in
                                        GeneratorTypeCard(
                                            type: type,
                                            isSelected: selectedType == type
                                        )
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                selectedType = type
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Character Count
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Characters")
                                        .font(Typography.headline)
                                        .foregroundColor(Palette.text)
                                    
                                    Spacer()
                                    
                                    Text("\(characterCount)")
                                        .font(Typography.title3)
                                        .foregroundColor(Palette.accent)
                                        .fontWeight(.bold)
                                }
                                
                                HStack(spacing: 12) {
                                    ForEach(Array(selectedDifficulty.characterCount), id: \.self) { count in
                                        Button(action: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                characterCount = count
                                            }
                                        }) {
                                            Text("\(count)")
                                                .font(Typography.callout)
                                                .fontWeight(.semibold)
                                                .foregroundColor(characterCount == count ? .white : Palette.accent)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 44)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(characterCount == count ? Palette.accent : Palette.accent.opacity(0.15))
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 40)
                }
                
                // Generate Button
                Button(action: generatePuzzle) {
                    HStack {
                        if isGenerating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            
                            Text("Generating...")
                                .font(Typography.headline)
                        } else {
                            Text("Generate Puzzle")
                                .font(Typography.headline)
                            
                            CustomIconView(name: "sparkle", size: 20)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isGenerating ? Palette.success.opacity(0.6) : Palette.success)
                    )
                }
                .disabled(isGenerating)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(item: $generatedPuzzle) { _ in
            PuzzleView()
        }
    }
    
    private func generatePuzzle() {
        isGenerating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            environment.startNewPuzzle(difficulty: selectedDifficulty, mode: .generator)
            generatedPuzzle = environment.currentPuzzle
            isGenerating = false
        }
    }
}

struct GeneratorOptionChip: View {
    let title: String
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(Typography.callout)
            .fontWeight(.semibold)
            .foregroundColor(isSelected ? .white : color)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? color : color.opacity(0.15))
            )
    }
}

struct GeneratorTypeCard: View {
    let type: PuzzleType
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Palette.accent.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                CustomIconView(name: typeIcon, size: 22)
                    .foregroundColor(Palette.accent)
            }
            
            Text(type.rawValue)
                .font(Typography.callout)
                .foregroundColor(Palette.text)
            
            Spacer()
            
            if isSelected {
                CustomIconView(name: "checkmark", size: 20)
                    .foregroundColor(Palette.success)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Palette.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Palette.accent : Color.clear, lineWidth: 2)
                )
        )
    }
    
    private var typeIcon: String {
        switch type {
        case .onlyOneTruth: return "person"
        case .allButOneLie: return "people"
        case .whoIsGuilty: return "questionmark"
        case .conditional: return "arrow-branch"
        }
    }
}
