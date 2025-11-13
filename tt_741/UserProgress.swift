

import Foundation

struct UserProgress: Codable {
    var totalPuzzlesSolved: Int = 0
    var totalPuzzlesFailed: Int = 0
    var bestMarathonScore: Int = 0
    var puzzlesByDifficulty: [String: Int] = [:]
    var puzzlesByType: [String: Int] = [:]
    var averageSolveTime: Double = 0
    var lastPlayedDate: Date?
    
    static func load() -> UserProgress {
        guard let data = UserDefaults.standard.data(forKey: "userProgress"),
              let progress = try? JSONDecoder().decode(UserProgress.self, from: data) else {
            return UserProgress()
        }
        return progress
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: "userProgress")
        }
    }
    
    mutating func recordSuccess(puzzle: Puzzle) {
        totalPuzzlesSolved += 1
        lastPlayedDate = Date()
        
        let diffKey = puzzle.difficulty.rawValue
        puzzlesByDifficulty[diffKey, default: 0] += 1
        
        let typeKey = puzzle.type.rawValue
        puzzlesByType[typeKey, default: 0] += 1
    }
    
    mutating func recordFailure(puzzle: Puzzle) {
        totalPuzzlesFailed += 1
        lastPlayedDate = Date()
    }
    
    mutating func updateMarathonScore(_ score: Int) {
        if score > bestMarathonScore {
            bestMarathonScore = score
        }
    }
    
    var successRate: Double {
        let total = totalPuzzlesSolved + totalPuzzlesFailed
        guard total > 0 else { return 0 }
        return Double(totalPuzzlesSolved) / Double(total) * 100
    }
}
