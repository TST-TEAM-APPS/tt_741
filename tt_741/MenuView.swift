
import SwiftUI

struct MenuView: View {
    @EnvironmentObject var environment: GameEnvironment
    @State private var showSettings = false
    @State private var selectedMode: GameMode?
    @State private var showStats = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Logo
                    ParadoxLogoView()
                        .padding(.bottom, 20)
                    
                    Text("PARADOX")
                        .font(Typography.largeTitle)
                        .foregroundColor(Palette.text)
                        .tracking(4)
                    
                    Text("Logic Mind Trainer")
                        .font(Typography.caption)
                        .foregroundColor(Palette.textSecondary)
                        .tracking(2)
                        .padding(.top, 4)
                    
                    Spacer()
                        .frame(height: 60)
                    
                    // Stats Card
                    StatsCardView()
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    
                    // Menu Buttons
                    VStack(spacing: 16) {
                        MenuButtonView(
                            icon: "puzzle",
                            title: "Puzzles",
                            subtitle: "Classic mode",
                            color: Palette.accent
                        ) {
                            selectedMode = .classic
                        }
                        
                        MenuButtonView(
                            icon: "infinity",
                            title: "Marathon",
                            subtitle: "Endless challenge",
                            color: Palette.error
                        ) {
                            selectedMode = .marathon
                        }
                        
                        MenuButtonView(
                            icon: "brain",
                            title: "Generator",
                            subtitle: "AI-powered puzzles",
                            color: Palette.success
                        ) {
                            selectedMode = .generator
                        }
                        
                        MenuButtonView(
                            icon: "book",
                            title: "Tutorial",
                            subtitle: "Learn the basics",
                            color: Palette.warning
                        ) {
                            selectedMode = .tutorial
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Settings Button
                    Button(action: { showSettings = true }) {
                        HStack(spacing: 8) {
                            CustomIconView(name: "gear", size: 18)
                            Text("Settings")
                                .font(Typography.callout)
                        }
                        .foregroundColor(Palette.textSecondary)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationDestination(item: $selectedMode) { mode in
                switch mode {
                case .classic:
                    DifficultySelectionView()
                case .marathon:
                    MarathonView()
                case .generator:
                    GeneratorView()
                case .tutorial:
                    TutorialView()
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

struct MenuButtonView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.opacity(0.15))
                        .frame(width: 56, height: 56)
                    
                    CustomIconView(name: icon, size: 28)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Typography.headline)
                        .foregroundColor(Palette.text)
                    
                    Text(subtitle)
                        .font(Typography.caption)
                        .foregroundColor(Palette.textSecondary)
                }
                
                Spacer()
                
                CustomIconView(name: "chevron", size: 20)
                    .foregroundColor(Palette.textSecondary)
                    .rotationEffect(.degrees(-90))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Palette.cardBackground)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatsCardView: View {
    @EnvironmentObject var environment: GameEnvironment
    
    var body: some View {
        HStack(spacing: 0) {
            StatItemView(
                value: "24",
                label: "Solved",
                color: Palette.success
            )
            
            Divider()
                .frame(height: 40)
                .padding(.horizontal, 16)
            
            StatItemView(
                value: "11",
                label: "Best Run",
                color: Palette.accent
            )
            
            Divider()
                .frame(height: 40)
                .padding(.horizontal, 16)
            
            StatItemView(
                value: String(format: "%.0f%%", environment.userProgress.successRate),
                label: "Success",
                color: Palette.warning
            )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Palette.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }
}

struct StatItemView: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(Typography.title2)
                .foregroundColor(color)
                .fontWeight(.bold)
            
            Text(label)
                .font(Typography.caption)
                .foregroundColor(Palette.textSecondary)
                .textCase(.uppercase)
                .tracking(1)
        }
        .frame(maxWidth: .infinity)
    }
}
