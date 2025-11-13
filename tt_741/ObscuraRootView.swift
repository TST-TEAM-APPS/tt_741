

import SwiftUI

struct ObscuraRootView<Content: View>: View {
    let content: Content
    @State private var particles: [ObscuraParticle] = []
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Palette.background
                .ignoresSafeArea()
            
            ObscuraParticleField(particles: $particles)
                .ignoresSafeArea()
                .opacity(0.15)
            
            content
        }
        .onAppear {
            generateParticles()
        }
    }
    
    private func generateParticles() {
        particles = (0..<30).map { _ in
            ObscuraParticle(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 2...8),
                opacity: Double.random(in: 0.1...0.3),
                speed: Double.random(in: 20...60)
            )
        }
    }
}

struct ObscuraParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let opacity: Double
    let speed: Double
}

struct ObscuraParticleField: View {
    @Binding var particles: [ObscuraParticle]
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                for particle in particles {
                    let phase = time * particle.speed
                    let x = particle.x + sin(phase) * 30
                    let y = particle.y + cos(phase * 0.7) * 20
                    
                    let rect = CGRect(x: x, y: y, width: particle.size, height: particle.size)
                    let path = Circle().path(in: rect)
                    
                    context.fill(path, with: .color(Palette.accent.opacity(particle.opacity)))
                }
            }
        }
    }
}

class ObscuraDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}
