import SwiftUI

struct ParadoxLogoView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(Palette.accent.opacity(0.2), lineWidth: 2)
                .frame(width: 80, height: 80)
            
            // Rotating elements
            ForEach(0..<3) { index in
                Circle()
                    .fill(Palette.accent)
                    .frame(width: 8, height: 8)
                    .offset(y: -35)
                    .rotationEffect(.degrees(rotation + Double(index) * 120))
            }
            
            // Center symbol
            Path { path in
                path.move(to: CGPoint(x: 0, y: -15))
                path.addLine(to: CGPoint(x: 13, y: 7.5))
                path.addLine(to: CGPoint(x: -13, y: 7.5))
                path.closeSubpath()
            }
            .stroke(Palette.accent, lineWidth: 2.5)
            .frame(width: 30, height: 30)
        }
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}
