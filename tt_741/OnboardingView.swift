
import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentStep = 0
    @State private var offsetX: CGFloat = 0
    
    let steps = [
        OnboardingStep(
            icon: "brain",
            title: "Master Logic",
            description: "Train your mind with challenging puzzles that test your logical reasoning",
            color: Palette.accent
        ),
        OnboardingStep(
            icon: "puzzle",
            title: "Solve Paradoxes",
            description: "Determine truth from lies by analyzing character statements",
            color: Palette.success
        ),
        OnboardingStep(
            icon: "flame",
            title: "Compete",
            description: "Challenge yourself in marathon mode and beat your best streak",
            color: Palette.error
        )
    ]
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        OnboardingStepView(step: steps[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Capsule()
                            .fill(currentStep == index ? steps[index].color : Palette.border)
                            .frame(width: currentStep == index ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentStep)
                    }
                }
                .padding(.vertical, 32)
                
                // Action Button
                Button(action: {
                    if currentStep < steps.count - 1 {
                        withAnimation {
                            currentStep += 1
                        }
                    } else {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                }) {
                    HStack {
                        Text(currentStep < steps.count - 1 ? "Continue" : "Get Started")
                            .font(Typography.headline)
                        
                        CustomIconView(name: "arrow", size: 20)
                            .rotationEffect(.degrees(-90))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(steps[currentStep].color)
                    )
                }
                .padding(.horizontal, 24)
                
                if currentStep < steps.count - 1 {
                    Button(action: {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }) {
                        Text("Skip")
                            .font(Typography.callout)
                            .foregroundColor(Palette.textSecondary)
                            .padding(.vertical, 16)
                    }
                }
                
                Spacer()
                    .frame(height: 40)
            }
        }
    }
}

struct OnboardingStep {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingStepView: View {
    let step: OnboardingStep
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                Circle()
                    .fill(step.color.opacity(0.15))
                    .frame(width: 160, height: 160)
                
                CustomIconView(name: step.icon, size: 80)
                    .foregroundColor(step.color)
            }
            
            VStack(spacing: 16) {
                Text(step.title)
                    .font(Typography.title1)
                    .foregroundColor(Palette.text)
                    .multilineTextAlignment(.center)
                
                Text(step.description)
                    .font(Typography.body)
                    .foregroundColor(Palette.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
        }
        .padding(.vertical, 60)
    }
}
