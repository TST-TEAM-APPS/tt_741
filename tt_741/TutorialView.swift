

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0
    
    let pages: [TutorialPage] = [
        TutorialPage(
            icon: "lightbulb",
            title: "Welcome to PARADOX",
            description: "Train your logical thinking by solving puzzles about truth and lies.",
            color: Palette.accent
        ),
        TutorialPage(
            icon: "people",
            title: "Characters",
            description: "Each puzzle has characters who make statements. Some tell the truth, others lie.",
            color: Palette.success
        ),
        TutorialPage(
            icon: "brain",
            title: "Your Task",
            description: "Determine who is truthful and who is lying based on their statements.",
            color: Palette.warning
        ),
        TutorialPage(
            icon: "checkmark",
            title: "Logic Rules",
            description: "If someone tells the truth, their statements are accurate. If they lie, their statements are false.",
            color: Palette.error
        ),
        TutorialPage(
            icon: "target",
            title: "Ready to Start",
            description: "Start with simple puzzles and progress to more complex challenges!",
            color: Palette.accent
        )
    ]
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Close Button
                HStack {
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        CustomIconView(name: "xmark", size: 20)
                            .foregroundColor(Palette.textSecondary)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(Palette.cardBackground)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                // Tutorial Pages
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        TutorialPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? pages[index].color : Palette.border)
                            .frame(width: 8, height: 8)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                    }
                }
                .padding(.vertical, 32)
                
                // Navigation Buttons
                HStack(spacing: 12) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text("Previous")
                                .font(Typography.headline)
                                .foregroundColor(Palette.text)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Palette.border, lineWidth: 1.5)
                                )
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            dismiss()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                                .font(Typography.headline)
                            
                            if currentPage < pages.count - 1 {
                                CustomIconView(name: "arrow", size: 20)
                                    .rotationEffect(.degrees(-90))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(pages[currentPage].color)
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

struct TutorialPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct TutorialPageView: View {
    let page: TutorialPage
    
    var body: some View {
        VStack(spacing: 32) {
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.15))
                    .frame(width: 140, height: 140)
                
                CustomIconView(name: page.icon, size: 70)
                    .foregroundColor(page.color)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(Typography.title1)
                    .foregroundColor(Palette.text)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(Typography.body)
                    .foregroundColor(Palette.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .padding(.vertical, 40)
    }
}
