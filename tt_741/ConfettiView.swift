

import SwiftUI

struct ConfettiView: View {
    @State private var confetti: [ConfettiPiece] = []
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                
                for piece in confetti {
                    let progress = (time - piece.startTime) / piece.duration
                    
                    guard progress >= 0 && progress <= 1 else { continue }
                    
                    let x = piece.startX + sin(time * piece.frequency) * piece.amplitude
                    let y = piece.startY + (size.height * CGFloat(progress))
                    let rotation = progress * piece.rotationSpeed * 360
                    let opacity = 1.0 - progress
                    
                    var contextCopy = context
                    contextCopy.opacity = opacity
                    contextCopy.translateBy(x: x, y: y)
                    contextCopy.rotate(by: .degrees(rotation))
                    
                    let rect = CGRect(x: -piece.size/2, y: -piece.size/2, width: piece.size, height: piece.size)
                    contextCopy.fill(Path(ellipseIn: rect), with: .color(piece.color))
                }
            }
        }
        .onAppear {
            generateConfetti()
        }
    }
    
    private func generateConfetti() {
        let colors: [Color] = [
            Palette.success, Palette.accent, Palette.warning,
            Palette.error, Color(hex: "FF2D55"), Color(hex: "5856D6")
        ]
        
        for _ in 0..<50 {
            let piece = ConfettiPiece(
                startX: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                startY: -20,
                size: CGFloat.random(in: 6...12),
                color: colors.randomElement() ?? Palette.accent,
                frequency: Double.random(in: 2...4),
                amplitude: CGFloat.random(in: 20...50),
                duration: Double.random(in: 2...3),
                rotationSpeed: Double.random(in: 1...3),
                startTime: Date().timeIntervalSinceReferenceDate + Double.random(in: 0...0.5)
            )
            confetti.append(piece)
        }
    }
}

struct ConfettiPiece {
    let startX: CGFloat
    let startY: CGFloat
    let size: CGFloat
    let color: Color
    let frequency: Double
    let amplitude: CGFloat
    let duration: Double
    let rotationSpeed: Double
    let startTime: TimeInterval
}
