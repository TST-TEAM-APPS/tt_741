import Foundation
import SwiftUI

struct Puzzle: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let difficulty: Difficulty
    let type: PuzzleType
    let characters: [Character]
    let statements: [Statement]
    let solution: Solution
    let createdAt: Date
    
    init(id: UUID = UUID(), title: String, difficulty: Difficulty, type: PuzzleType, characters: [Character], statements: [Statement], solution: Solution) {
        self.id = id
        self.title = title
        self.difficulty = difficulty
        self.type = type
        self.characters = characters
        self.statements = statements
        self.solution = solution
        self.createdAt = Date()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Puzzle, rhs: Puzzle) -> Bool {
        lhs.id == rhs.id
    }
}

enum Difficulty: String, Codable, CaseIterable, Hashable {
    case novice = "Novice"
    case analyst = "Analyst"
    case expert = "Expert"
    case sage = "Sage"
    
    var characterCount: ClosedRange<Int> {
        switch self {
        case .novice: return 2...3
        case .analyst: return 3...4
        case .expert: return 4...5
        case .sage: return 5...6
        }
    }
    
    var color: Color {
        switch self {
        case .novice: return Color(hex: "34C759")
        case .analyst: return Color(hex: "007AFF")
        case .expert: return Color(hex: "FF9500")
        case .sage: return Color(hex: "FF3B30")
        }
    }
}

enum PuzzleType: String, Codable, CaseIterable, Hashable {
    case onlyOneTruth = "Only One Speaks Truth"
    case allButOneLie = "All But One Lie"
    case whoIsGuilty = "Who Is Guilty?"
    case conditional = "Conditional Logic"
    
    var icon: String {
        switch self {
        case .onlyOneTruth: return "person.fill.checkmark"
        case .allButOneLie: return "person.fill.xmark"
        case .whoIsGuilty: return "questionmark.circle.fill"
        case .conditional: return "arrow.triangle.branch"
        }
    }
}
