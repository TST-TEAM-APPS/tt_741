
import SwiftUI

struct CustomIconView: View {
    let name: String
    let size: CGFloat
    
    var body: some View {
        Group {
            switch name {
            case "puzzle":
                PuzzleIcon()
            case "infinity":
                InfinityIcon()
            case "brain":
                BrainIcon()
            case "book":
                BookIcon()
            case "gear":
                GearIcon()
            case "chevron":
                ChevronIcon()
            case "checkmark":
                CheckmarkIcon()
            case "xmark":
                XmarkIcon()
            case "arrow":
                ArrowIcon()
            case "play":
                PlayIcon()
            case "flame":
                FlameIcon()
            case "info":
                InfoIcon()
            case "refresh":
                RefreshIcon()
            case "target":
                TargetIcon()
            case "chart":
                ChartIcon()
            case "trophy":
                TrophyIcon()
            case "sparkle":
                SparkleIcon()
            case "person":
                PersonIcon()
            case "people":
                PeopleIcon()
            case "questionmark":
                QuestionMarkIcon()
            case "arrow-branch":
                ArrowBranchIcon()
            case "lightbulb":
                LightbulbIcon()
            case "speaker":
                SpeakerIcon()
            case "hand":
                HandIcon()
            case "trash":
                TrashIcon()
            case "heart":
                HeartIcon()
            case "envelope":
                EnvelopeIcon()
            default:
                DefaultIcon()
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Icon Shapes

struct PuzzleIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Puzzle piece outline
                p.move(to: CGPoint(x: size.width * 0.2, y: size.height * 0.2))
                p.addLine(to: CGPoint(x: size.width * 0.45, y: size.height * 0.2))
                p.addArc(center: CGPoint(x: size.width * 0.5, y: size.height * 0.15),
                        radius: size.width * 0.1,
                        startAngle: .degrees(180),
                        endAngle: .degrees(0),
                        clockwise: false)
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.2))
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.45))
                p.addArc(center: CGPoint(x: size.width * 0.85, y: size.height * 0.5),
                        radius: size.width * 0.1,
                        startAngle: .degrees(270),
                        endAngle: .degrees(90),
                        clockwise: false)
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.8))
                p.addLine(to: CGPoint(x: size.width * 0.2, y: size.height * 0.8))
                p.addLine(to: CGPoint(x: size.width * 0.2, y: size.height * 0.2))
            }
            context.stroke(path, with: .color(.primary), lineWidth: 2)
        }
    }
}

struct InfinityIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                let centerY = size.height / 2
                let leftX = size.width * 0.25
                let rightX = size.width * 0.75
                
                p.move(to: CGPoint(x: size.width * 0.1, y: centerY))
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.5, y: centerY),
                    control: CGPoint(x: leftX, y: centerY - size.height * 0.25)
                )
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.9, y: centerY),
                    control: CGPoint(x: rightX, y: centerY + size.height * 0.25)
                )
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.5, y: centerY),
                    control: CGPoint(x: rightX, y: centerY - size.height * 0.25)
                )
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.1, y: centerY),
                    control: CGPoint(x: leftX, y: centerY + size.height * 0.25)
                )
            }
            context.stroke(path, with: .color(.primary), lineWidth: 2.5)
        }
    }
}

struct BrainIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Left hemisphere
                p.addArc(center: CGPoint(x: size.width * 0.35, y: size.height * 0.5),
                        radius: size.width * 0.25,
                        startAngle: .degrees(90),
                        endAngle: .degrees(270),
                        clockwise: false)
                
                // Right hemisphere
                p.addArc(center: CGPoint(x: size.width * 0.65, y: size.height * 0.5),
                        radius: size.width * 0.25,
                        startAngle: .degrees(270),
                        endAngle: .degrees(90),
                        clockwise: false)
                
                // Brain folds
                p.move(to: CGPoint(x: size.width * 0.3, y: size.height * 0.4))
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.3, y: size.height * 0.6),
                    control: CGPoint(x: size.width * 0.25, y: size.height * 0.5)
                )
                
                p.move(to: CGPoint(x: size.width * 0.7, y: size.height * 0.4))
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.7, y: size.height * 0.6),
                    control: CGPoint(x: size.width * 0.75, y: size.height * 0.5)
                )
            }
            context.stroke(path, with: .color(.primary), lineWidth: 2)
        }
    }
}

struct BookIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Book outline
                p.addRoundedRect(
                    in: CGRect(x: size.width * 0.2, y: size.height * 0.15,
                              width: size.width * 0.6, height: size.height * 0.7),
                    cornerSize: CGSize(width: 3, height: 3)
                )
                
                // Spine
                p.move(to: CGPoint(x: size.width * 0.2, y: size.height * 0.15))
                p.addLine(to: CGPoint(x: size.width * 0.2, y: size.height * 0.85))
                
                // Pages
                p.move(to: CGPoint(x: size.width * 0.35, y: size.height * 0.35))
                p.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.35))
                
                p.move(to: CGPoint(x: size.width * 0.35, y: size.height * 0.5))
                p.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.5))
                
                p.move(to: CGPoint(x: size.width * 0.35, y: size.height * 0.65))
                p.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.65))
            }
            context.stroke(path, with: .color(.primary), lineWidth: 2)
        }
    }
}

struct GearIcon: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let outerRadius = size.width * 0.4
            let innerRadius = size.width * 0.25
            let teethCount = 8
            
            let path = Path { p in
                for i in 0..<teethCount {
                    let angle1 = Double(i) * 360.0 / Double(teethCount)
                    let angle2 = angle1 + 180.0 / Double(teethCount)
                    let angle3 = Double(i + 1) * 360.0 / Double(teethCount)
                    
                    let outer1 = CGPoint(
                        x: center.x + outerRadius * cos(angle1 * .pi / 180),
                        y: center.y + outerRadius * sin(angle1 * .pi / 180)
                    )
                    let inner = CGPoint(
                        x: center.x + innerRadius * cos(angle2 * .pi / 180),
                        y: center.y + innerRadius * sin(angle2 * .pi / 180)
                    )
                    let outer2 = CGPoint(
                        x: center.x + outerRadius * cos(angle3 * .pi / 180),
                        y: center.y + outerRadius * sin(angle3 * .pi / 180)
                    )
                    
                    if i == 0 {
                        p.move(to: outer1)
                    }
                    p.addLine(to: outer1)
                    p.addLine(to: inner)
                    p.addLine(to: outer2)
                }
                p.closeSubpath()
                
                // Center circle
                p.addEllipse(in: CGRect(
                    x: center.x - size.width * 0.15,
                    y: center.y - size.width * 0.15,
                    width: size.width * 0.3,
                    height: size.width * 0.3
                ))
            }
            context.stroke(path, with: .color(.primary), lineWidth: 2)
        }
    }
}

struct ChevronIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                p.move(to: CGPoint(x: size.width * 0.3, y: size.height * 0.2))
                p.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.5))
                p.addLine(to: CGPoint(x: size.width * 0.3, y: size.height * 0.8))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        }
    }
}

struct CheckmarkIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                p.move(to: CGPoint(x: size.width * 0.2, y: size.height * 0.5))
                p.addLine(to: CGPoint(x: size.width * 0.45, y: size.height * 0.75))
                p.addLine(to: CGPoint(x: size.width * 0.85, y: size.height * 0.25))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        }
    }
}

struct XmarkIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                p.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.25))
                p.addLine(to: CGPoint(x: size.width * 0.75, y: size.height * 0.75))
                p.move(to: CGPoint(x: size.width * 0.75, y: size.height * 0.25))
                p.addLine(to: CGPoint(x: size.width * 0.25, y: size.height * 0.75))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 3, lineCap: .round))
        }
    }
}

struct ArrowIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                p.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.2))
                p.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.8))
                
                p.move(to: CGPoint(x: size.width * 0.3, y: size.height * 0.6))
                p.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.8))
                p.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.6))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        }
    }
}

struct PlayIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                p.move(to: CGPoint(x: size.width * 0.3, y: size.height * 0.2))
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.5))
                p.addLine(to: CGPoint(x: size.width * 0.3, y: size.height * 0.8))
                p.closeSubpath()
            }
            context.fill(path, with: .color(.primary))
        }
    }
}

struct FlameIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                p.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.9))
                
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.3, y: size.height * 0.5),
                    control: CGPoint(x: size.width * 0.2, y: size.height * 0.7)
                )
                
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.5, y: size.height * 0.1),
                    control: CGPoint(x: size.width * 0.35, y: size.height * 0.2)
                )
                
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.7, y: size.height * 0.5),
                    control: CGPoint(x: size.width * 0.65, y: size.height * 0.2)
                )
                
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.5, y: size.height * 0.9),
                    control: CGPoint(x: size.width * 0.8, y: size.height * 0.7)
                )
            }
            context.fill(path, with: .color(.primary))
        }
    }
}

struct InfoIcon: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = size.width * 0.4
            
            // Circle
            let circle = Path { p in
                p.addEllipse(in: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                ))
            }
            context.stroke(circle, with: .color(.primary), lineWidth: 2)
            
            // i dot
            let dot = Path { p in
                p.addEllipse(in: CGRect(
                    x: center.x - 2,
                    y: center.y - radius * 0.5,
                    width: 4,
                    height: 4
                ))
            }
            context.fill(dot, with: .color(.primary))
            
            // i line
            let line = Path { p in
                p.move(to: CGPoint(x: center.x, y: center.y - radius * 0.2))
                p.addLine(to: CGPoint(x: center.x, y: center.y + radius * 0.5))
            }
            context.stroke(line, with: .color(.primary), lineWidth: 2.5)
        }
    }
}

struct RefreshIcon: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = size.width * 0.35
            
            let path = Path { p in
                p.addArc(center: center, radius: radius,
                        startAngle: .degrees(45),
                        endAngle: .degrees(315),
                        clockwise: false)
                
                // Arrow
                let arrowEnd = CGPoint(
                    x: center.x + radius * cos(45 * .pi / 180),
                    y: center.y + radius * sin(45 * .pi / 180)
                )
                p.move(to: arrowEnd)
                p.addLine(to: CGPoint(x: arrowEnd.x - 8, y: arrowEnd.y - 5))
                p.move(to: arrowEnd)
                p.addLine(to: CGPoint(x: arrowEnd.x + 5, y: arrowEnd.y - 8))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        }
    }
}

struct TargetIcon: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            
            for i in 1...3 {
                let radius = size.width * 0.15 * CGFloat(i)
                let circle = Path { p in
                    p.addEllipse(in: CGRect(
                        x: center.x - radius,
                        y: center.y - radius,
                        width: radius * 2,
                        height: radius * 2
                    ))
                }
                context.stroke(circle, with: .color(.primary), lineWidth: 2)
            }
            
            // Center dot
            let dot = Path { p in
                p.addEllipse(in: CGRect(
                    x: center.x - 3,
                    y: center.y - 3,
                    width: 6,
                    height: 6
                ))
            }
            context.fill(dot, with: .color(.primary))
        }
    }
}

struct ChartIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                let bars: [(x: CGFloat, height: CGFloat)] = [
                    (0.2, 0.4),
                    (0.4, 0.7),
                    (0.6, 0.5),
                    (0.8, 0.8)
                ]
                
                for bar in bars {
                    let rect = CGRect(
                        x: size.width * bar.x - size.width * 0.05,
                        y: size.height * (1.0 - bar.height),
                        width: size.width * 0.1,
                        height: size.height * bar.height
                    )
                    p.addRoundedRect(in: rect, cornerSize: CGSize(width: 2, height: 2))
                }
            }
            context.fill(path, with: .color(.primary))
        }
    }
}

struct TrophyIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Cup
                p.move(to: CGPoint(x: size.width * 0.3, y: size.height * 0.2))
                p.addLine(to: CGPoint(x: size.width * 0.35, y: size.height * 0.5))
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.65, y: size.height * 0.5),
                    control: CGPoint(x: size.width * 0.5, y: size.height * 0.6)
                )
                p.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.2))
                p.closeSubpath()
                
                // Handles
                p.move(to: CGPoint(x: size.width * 0.3, y: size.height * 0.25))
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.3, y: size.height * 0.4),
                    control: CGPoint(x: size.width * 0.2, y: size.height * 0.33)
                )
                
                p.move(to: CGPoint(x: size.width * 0.7, y: size.height * 0.25))
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.7, y: size.height * 0.4),
                    control: CGPoint(x: size.width * 0.8, y: size.height * 0.33)
                )
                
                // Base
                p.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.5))
                p.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.7))
                
                p.move(to: CGPoint(x: size.width * 0.35, y: size.height * 0.7))
                p.addLine(to: CGPoint(x: size.width * 0.65, y: size.height * 0.7))
                
                p.addRect(CGRect(x: size.width * 0.4, y: size.height * 0.7, width: size.width * 0.2, height: size.height * 0.1))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

struct SparkleIcon: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let path = Path { p in
                // Main cross
                p.move(to: CGPoint(x: center.x, y: size.height * 0.15))
                p.addLine(to: CGPoint(x: center.x, y: size.height * 0.85))
                
                p.move(to: CGPoint(x: size.width * 0.15, y: center.y))
                p.addLine(to: CGPoint(x: size.width * 0.85, y: center.y))
                
                // Diagonal cross
                p.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.25))
                p.addLine(to: CGPoint(x: size.width * 0.75, y: size.height * 0.75))
                
                p.move(to: CGPoint(x: size.width * 0.75, y: size.height * 0.25))
                p.addLine(to: CGPoint(x: size.width * 0.25, y: size.height * 0.75))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
        }
    }
}

struct PersonIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Head
                p.addEllipse(in: CGRect(
                    x: size.width * 0.35,
                    y: size.height * 0.15,
                    width: size.width * 0.3,
                    height: size.height * 0.3
                ))
                
                // Body
                p.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.45))
                p.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.65))
                
                // Arms
                p.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.55))
                p.addLine(to: CGPoint(x: size.width * 0.75, y: size.height * 0.55))
                
                // Legs
                p.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.65))
                p.addLine(to: CGPoint(x: size.width * 0.35, y: size.height * 0.85))
                
                p.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.65))
                p.addLine(to: CGPoint(x: size.width * 0.65, y: size.height * 0.85))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
    }
}

struct PeopleIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Person 1
                p.addEllipse(in: CGRect(x: size.width * 0.25, y: size.height * 0.2,
                                       width: size.width * 0.2, height: size.height * 0.2))
                p.move(to: CGPoint(x: size.width * 0.35, y: size.height * 0.4))
                p.addLine(to: CGPoint(x: size.width * 0.35, y: size.height * 0.6))
                
                // Person 2
                p.addEllipse(in: CGRect(x: size.width * 0.55, y: size.height * 0.2,
                                       width: size.width * 0.2, height: size.height * 0.2))
                p.move(to: CGPoint(x: size.width * 0.65, y: size.height * 0.4))
                p.addLine(to: CGPoint(x: size.width * 0.65, y: size.height * 0.6))
            }
            context.stroke(path, with: .color(.primary), lineWidth: 2)
        }
    }
}

struct QuestionMarkIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                let centerX = size.width / 2
                
                // Question mark curve
                p.addArc(center: CGPoint(x: centerX, y: size.height * 0.25),
                        radius: size.width * 0.15,
                        startAngle: .degrees(180),
                        endAngle: .degrees(0),
                        clockwise: false)
                
                p.addLine(to: CGPoint(x: centerX, y: size.height * 0.55))
                
                // Dot
                p.addEllipse(in: CGRect(
                    x: centerX - 3,
                    y: size.height * 0.7,
                    width: 6,
                    height: 6
                ))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
        }
    }
}

struct ArrowBranchIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Main arrow
                p.move(to: CGPoint(x: size.width * 0.2, y: size.height * 0.5))
                p.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.5))
                
                // Branch up
                p.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.5))
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.25))
                
                // Arrow head up
                p.move(to: CGPoint(x: size.width * 0.75, y: size.height * 0.3))
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.25))
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.32))
                
                // Branch down
                p.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.5))
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.75))
                
                // Arrow head down
                p.move(to: CGPoint(x: size.width * 0.75, y: size.height * 0.7))
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.75))
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.68))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        }
    }
}

struct LightbulbIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Bulb
                let center = CGPoint(x: size.width / 2, y: size.height * 0.35)
                let radius = size.width * 0.25
                
                p.addArc(center: center, radius: radius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(0),
                        clockwise: false)
                
                // Base
                p.move(to: CGPoint(x: size.width * 0.4, y: size.height * 0.6))
                p.addLine(to: CGPoint(x: size.width * 0.4, y: size.height * 0.7))
                p.addLine(to: CGPoint(x: size.width * 0.6, y: size.height * 0.7))
                p.addLine(to: CGPoint(x: size.width * 0.6, y: size.height * 0.6))
                
                // Filament
                p.move(to: CGPoint(x: size.width * 0.5, y: size.height * 0.25))
                p.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.45))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

struct SpeakerIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Speaker
                p.move(to: CGPoint(x: size.width * 0.2, y: size.height * 0.35))
                p.addLine(to: CGPoint(x: size.width * 0.4, y: size.height * 0.35))
                p.addLine(to: CGPoint(x: size.width * 0.6, y: size.height * 0.2))
                p.addLine(to: CGPoint(x: size.width * 0.6, y: size.height * 0.8))
                p.addLine(to: CGPoint(x: size.width * 0.4, y: size.height * 0.65))
                p.addLine(to: CGPoint(x: size.width * 0.2, y: size.height * 0.65))
                p.closeSubpath()
                
                // Sound waves
                p.move(to: CGPoint(x: size.width * 0.7, y: size.height * 0.35))
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.7, y: size.height * 0.65),
                    control: CGPoint(x: size.width * 0.85, y: size.height * 0.5)
                )
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

struct HandIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Palm
                p.move(to: CGPoint(x: size.width * 0.3, y: size.height * 0.7))
                p.addLine(to: CGPoint(x: size.width * 0.3, y: size.height * 0.4))
                
                // Fingers
                for i in 0..<4 {
                    let xOffset = CGFloat(i) * 0.1
                    p.move(to: CGPoint(x: size.width * (0.35 + xOffset), y: size.height * 0.4))
                    p.addLine(to: CGPoint(x: size.width * (0.35 + xOffset), y: size.height * 0.2))
                }
                
                p.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.4))
                p.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.7))
                p.addLine(to: CGPoint(x: size.width * 0.3, y: size.height * 0.7))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

struct TrashIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Can
                p.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.3))
                p.addLine(to: CGPoint(x: size.width * 0.3, y: size.height * 0.8))
                p.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.8))
                p.addLine(to: CGPoint(x: size.width * 0.75, y: size.height * 0.3))
                p.closeSubpath()
                
                // Top line
                p.move(to: CGPoint(x: size.width * 0.2, y: size.height * 0.3))
                p.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.3))
                
                // Lid
                p.move(to: CGPoint(x: size.width * 0.4, y: size.height * 0.3))
                p.addLine(to: CGPoint(x: size.width * 0.4, y: size.height * 0.2))
                p.addLine(to: CGPoint(x: size.width * 0.6, y: size.height * 0.2))
                p.addLine(to: CGPoint(x: size.width * 0.6, y: size.height * 0.3))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

struct HeartIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                let centerX = size.width / 2
                let topY = size.height * 0.3
                
                p.move(to: CGPoint(x: centerX, y: size.height * 0.8))
                
                // Left side
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.2, y: topY),
                    control: CGPoint(x: size.width * 0.25, y: size.height * 0.5)
                )
                
                p.addQuadCurve(
                    to: CGPoint(x: centerX, y: topY),
                    control: CGPoint(x: size.width * 0.2, y: size.height * 0.15)
                )
                
                // Right side
                p.addQuadCurve(
                    to: CGPoint(x: size.width * 0.8, y: topY),
                    control: CGPoint(x: size.width * 0.8, y: size.height * 0.15)
                )
                
                p.addQuadCurve(
                    to: CGPoint(x: centerX, y: size.height * 0.8),
                    control: CGPoint(x: size.width * 0.75, y: size.height * 0.5)
                )
            }
            context.fill(path, with: .color(.primary))
        }
    }
}

struct EnvelopeIcon: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                // Envelope outline
                p.addRect(CGRect(
                    x: size.width * 0.15,
                    y: size.height * 0.25,
                    width: size.width * 0.7,
                    height: size.height * 0.5
                ))
                
                // Flap
                p.move(to: CGPoint(x: size.width * 0.15, y: size.height * 0.25))
                p.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.5))
                p.addLine(to: CGPoint(x: size.width * 0.85, y: size.height * 0.25))
            }
            context.stroke(path, with: .color(.primary), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
}

struct DefaultIcon: View {
    var body: some View {
        Circle()
            .stroke(Color.primary, lineWidth: 2)
    }
}
