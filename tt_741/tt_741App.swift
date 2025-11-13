import SwiftUI

@main
struct ParadoxApp: App {
    @UIApplicationDelegateAdaptor(ObscuraDelegate.self) var appDelegate
    @StateObject private var gameEnvironment = GameEnvironment()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            ObscuraRootView {
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
