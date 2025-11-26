import SwiftUI
import FirebaseCore

@main
struct ParadoxApp: App {
    @UIApplicationDelegateAdaptor(NightfallDelegate.self) var appDelegate
    @StateObject private var gameEnvironment = GameEnvironment()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            NightfallRootView {
                Group {
                    if hasCompletedOnboarding {
                        MenuView()
                            .environmentObject(gameEnvironment)
                    } else {
                        OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    }
                }
                .preferredColorScheme(.light)
            }
            .environmentObject(appDelegate)
        }
    }
}
