


import SwiftUI

struct ResultView: View {
    @EnvironmentObject var environment: GameEnvironment
    @Environment(\.dismiss) var dismiss
    let onContinue: () -> Void
    let onExit: () -> Void
    
    @State private var animateResult = false
    @State private var animateSteps = false
    @State private var confettiTrigger = false
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 60)
                
                // Result Icon
                ZStack {
                    Circle()
                        .fill(resultColor.opacity(0.15))
                        .frame(width: 120, height: 120)
                        .scaleEffect(animateResult ? 1.0 : 0.3)
                        .opacity(animateResult ? 1.0 : 0)
                    
                    CustomIconView(
                        name: environment.isCorrect ? "checkmark" : "xmark",
                        size: 60
                    )
                    .foregroundColor(resultColor)
                    .scaleEffect(animateResult ? 1.0 : 0.3)
                    .opacity(animateResult ? 1.0 : 0)
                }
                .padding(.bottom, 24)
                
                // Result Title
                Text(environment.isCorrect ? "Truth Found!" : "Paradox Remains")
                    .font(Typography.title1)
                    .foregroundColor(Palette.text)
                    .opacity(animateResult ? 1.0 : 0)
                    .offset(y: animateResult ? 0 : 20)
                
                Text(environment.isCorrect ? "Your logic is flawless" : "Review the reasoning")
                    .font(Typography.callout)
                    .foregroundColor(Palette.textSecondary)
                    .padding(.top, 8)
                    .opacity(animateResult ? 1.0 : 0)
                    .offset(y: animateResult ? 0 : 20)
                
                if environment.marathonActive {
                    HStack(spacing: 8) {
                        CustomIconView(name: "flame", size: 24)
                            .foregroundColor(Palette.error)
                        
                        Text("Streak: \(environment.marathonScore)")
                            .font(Typography.title3)
                            .foregroundColor(Palette.text)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 20)
                    .opacity(animateResult ? 1.0 : 0)
                }
                
                Spacer()
                    .frame(height: 40)
                
                // Explanation
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Explanation")
                            .font(Typography.headline)
                            .foregroundColor(Palette.text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                        
                        ForEach(Array(environment.explanation.enumerated()), id: \.element.id) { index, step in
                            ExplanationStepView(step: step, index: index)
                                .padding(.horizontal, 24)
                                .opacity(animateSteps ? 1.0 : 0)
                                .offset(x: animateSteps ? 0 : -20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateSteps)
                        }
                    }
                    .padding(.vertical, 20)
                }
                .frame(maxHeight: 300)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    if environment.isCorrect {
                        Button(action: {
                            dismiss()
                            onContinue()
                        }) {
                            HStack {
                                Text(environment.marathonActive ? "Next Puzzle" : "Continue")
                                    .font(Typography.headline)
                                
                                CustomIconView(name: "arrow", size: 20)
                                    .rotationEffect(.degrees(-90))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Palette.success)
                            )
                        }
                    } else {
                        Button(action: {
                            dismiss()
                            onContinue()
                        }) {
                            HStack {
                                Text("Try Again")
                                    .font(Typography.headline)
                                
                                CustomIconView(name: "refresh", size: 20)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Palette.accent)
                            )
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                        onExit()
                    }) {
                        Text("Exit")
                            .font(Typography.headline)
                            .foregroundColor(Palette.textSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Palette.border, lineWidth: 1.5)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            
            if environment.isCorrect && confettiTrigger {
                ConfettiView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animateResult = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    animateSteps = true
                }
            }
            
            if environment.isCorrect {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    confettiTrigger = true
                }
            }
        }
    }
    
    private var resultColor: Color {
        environment.isCorrect ? Palette.success : Palette.error
    }
}

struct ExplanationStepView: View {
    let step: LogicStep
    let index: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Palette.accent.opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Text("\(step.step)")
                    .font(Typography.callout)
                    .foregroundColor(Palette.accent)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(step.description)
                    .font(Typography.callout)
                    .foregroundColor(Palette.text)
                
                if !step.conclusion.isEmpty {
                    Text(step.conclusion)
                        .font(Typography.caption)
                        .foregroundColor(Palette.textSecondary)
                        .padding(.top, 4)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Palette.cardBackground)
        )
    }
}
