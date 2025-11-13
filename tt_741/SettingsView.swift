
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var environment: GameEnvironment
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("showHints") private var showHints = true
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Palette.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // App Info
                        VStack(spacing: 12) {
                            ParadoxLogoView()
                            
                            Text("PARADOX")
                                .font(Typography.title3)
                                .foregroundColor(Palette.text)
                                .tracking(2)
                            
                            Text("Version 1.0.0")
                                .font(Typography.caption)
                                .foregroundColor(Palette.textSecondary)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        
                        // Settings Sections
                        VStack(spacing: 16) {
                            SettingsSection(title: "Preferences") {
                                SettingsToggleRow(
                                    icon: "speaker",
                                    title: "Sound Effects",
                                    isOn: $soundEnabled
                                )
                                
                                SettingsToggleRow(
                                    icon: "hand",
                                    title: "Haptic Feedback",
                                    isOn: $hapticsEnabled
                                )
                                
                                SettingsToggleRow(
                                    icon: "lightbulb",
                                    title: "Show Hints",
                                    isOn: $showHints
                                )
                            }
                            
                            SettingsSection(title: "Statistics") {
                                SettingsStatRow(
                                    title: "Puzzles Solved",
                                    value: "\(environment.userProgress.totalPuzzlesSolved)"
                                )
                                
                                SettingsStatRow(
                                    title: "Success Rate",
                                    value: String(format: "%.1f%%", environment.userProgress.successRate)
                                )
                                
                                SettingsStatRow(
                                    title: "Best Marathon",
                                    value: "\(environment.userProgress.bestMarathonScore)"
                                )
                            }
                            
                            SettingsSection(title: "Data") {
                                Button(action: { showResetAlert = true }) {
                                    HStack {
                                        CustomIconView(name: "trash", size: 20)
                                            .foregroundColor(Palette.error)
                                        
                                        Text("Reset Progress")
                                            .font(Typography.callout)
                                            .foregroundColor(Palette.error)
                                        
                                        Spacer()
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Palette.cardBackground)
                                    )
                                }
                            }
                            
                            SettingsSection(title: "About") {
                                SettingsLinkRow(
                                    icon: "info",
                                    title: "How to Play"
                                ) {
                                    // Action
                                }
                                
                                SettingsLinkRow(
                                    icon: "heart",
                                    title: "Rate App"
                                ) {
                                    // Action
                                }
                                
                                SettingsLinkRow(
                                    icon: "envelope",
                                    title: "Contact Support"
                                ) {
                                    // Action
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Palette.accent)
                }
            }
            .alert("Reset Progress", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    environment.userProgress = UserProgress()
                    environment.userProgress.save()
                }
            } message: {
                Text("Are you sure you want to reset all your progress? This action cannot be undone.")
            }
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Typography.caption)
                .foregroundColor(Palette.textSecondary)
                .textCase(.uppercase)
                .tracking(1)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
        }
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            CustomIconView(name: icon, size: 20)
                .foregroundColor(Palette.accent)
                .frame(width: 24)
            
            Text(title)
                .font(Typography.callout)
                .foregroundColor(Palette.text)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Palette.accent)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Palette.cardBackground)
        )
    }
}

struct SettingsStatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(Typography.callout)
                .foregroundColor(Palette.text)
            
            Spacer()
            
            Text(value)
                .font(Typography.callout)
                .foregroundColor(Palette.accent)
                .fontWeight(.semibold)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Palette.cardBackground)
        )
    }
}

struct SettingsLinkRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                CustomIconView(name: icon, size: 20)
                    .foregroundColor(Palette.accent)
                    .frame(width: 24)
                
                Text(title)
                    .font(Typography.callout)
                    .foregroundColor(Palette.text)
                
                Spacer()
                
                CustomIconView(name: "chevron", size: 16)
                    .foregroundColor(Palette.textSecondary)
                    .rotationEffect(.degrees(-90))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Palette.cardBackground)
            )
        }
    }
}
