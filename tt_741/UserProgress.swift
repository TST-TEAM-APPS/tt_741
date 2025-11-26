import Foundation

struct UserProgress: Codable {
    var totalPuzzlesSolved: Int = 0
    var totalPuzzlesFailed: Int = 0
    var bestMarathonScore: Int = 0
    var puzzlesByDifficulty: [String: Int] = [:]
    var puzzlesByType: [String: Int] = [:]
    var averageSolveTime: Double = 0
    var lastPlayedDate: Date?
    var dailyStreak: Int = 0
    var totalHintsUsed: Int = 0
    var perfectSolves: Int = 0
    var achievements: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case totalPuzzlesSolved
        case totalPuzzlesFailed
        case bestMarathonScore
        case puzzlesByDifficulty
        case puzzlesByType
        case averageSolveTime
        case lastPlayedDate
        case dailyStreak
        case totalHintsUsed
        case perfectSolves
        case achievements
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalPuzzlesSolved = try container.decodeIfPresent(Int.self, forKey: .totalPuzzlesSolved) ?? 0
        totalPuzzlesFailed = try container.decodeIfPresent(Int.self, forKey: .totalPuzzlesFailed) ?? 0
        bestMarathonScore = try container.decodeIfPresent(Int.self, forKey: .bestMarathonScore) ?? 0
        puzzlesByDifficulty = try container.decodeIfPresent([String: Int].self, forKey: .puzzlesByDifficulty) ?? [:]
        puzzlesByType = try container.decodeIfPresent([String: Int].self, forKey: .puzzlesByType) ?? [:]
        averageSolveTime = try container.decodeIfPresent(Double.self, forKey: .averageSolveTime) ?? 0
        lastPlayedDate = try container.decodeIfPresent(Date.self, forKey: .lastPlayedDate)
        dailyStreak = try container.decodeIfPresent(Int.self, forKey: .dailyStreak) ?? 0
        totalHintsUsed = try container.decodeIfPresent(Int.self, forKey: .totalHintsUsed) ?? 0
        perfectSolves = try container.decodeIfPresent(Int.self, forKey: .perfectSolves) ?? 0
        achievements = try container.decodeIfPresent([String].self, forKey: .achievements) ?? []
    }
    
    init() {
        self.totalPuzzlesSolved = 0
        self.totalPuzzlesFailed = 0
        self.bestMarathonScore = 0
        self.puzzlesByDifficulty = [:]
        self.puzzlesByType = [:]
        self.averageSolveTime = 0
        self.lastPlayedDate = nil
        self.dailyStreak = 0
        self.totalHintsUsed = 0
        self.perfectSolves = 0
        self.achievements = []
    }
    
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
        
        checkAchievements()
    }
    
    mutating func recordFailure(puzzle: Puzzle) {
        totalPuzzlesFailed += 1
        lastPlayedDate = Date()
    }
    
    mutating func updateMarathonScore(_ score: Int) {
        if score > bestMarathonScore {
            bestMarathonScore = score
            checkAchievements()
        }
    }
    
    mutating func useHint() {
        totalHintsUsed += 1
    }
    
    mutating func recordPerfectSolve() {
        perfectSolves += 1
        checkAchievements()
    }
    
    private mutating func checkAchievements() {
        var newAchievements: [String] = []
        
        if totalPuzzlesSolved >= 10 && !achievements.contains("first_ten") {
            newAchievements.append("first_ten")
        }
        
        if totalPuzzlesSolved >= 50 && !achievements.contains("puzzle_master") {
            newAchievements.append("puzzle_master")
        }
        
        if totalPuzzlesSolved >= 100 && !achievements.contains("century") {
            newAchievements.append("century")
        }
        
        if bestMarathonScore >= 10 && !achievements.contains("marathon_pro") {
            newAchievements.append("marathon_pro")
        }
        
        if bestMarathonScore >= 25 && !achievements.contains("unstoppable") {
            newAchievements.append("unstoppable")
        }
        
        if dailyStreak >= 7 && !achievements.contains("week_warrior") {
            newAchievements.append("week_warrior")
        }
        
        if dailyStreak >= 30 && !achievements.contains("dedication") {
            newAchievements.append("dedication")
        }
        
        if successRate >= 90 && totalPuzzlesSolved >= 20 && !achievements.contains("perfectionist") {
            newAchievements.append("perfectionist")
        }
        
        achievements.append(contentsOf: newAchievements)
    }
    
    var successRate: Double {
        let total = totalPuzzlesSolved + totalPuzzlesFailed
        guard total > 0 else { return 0 }
        return Double(totalPuzzlesSolved) / Double(total) * 100
    }
    
    var level: Int {
        return min(totalPuzzlesSolved / 10 + 1, 50)
    }
    
    var progressToNextLevel: Double {
        let currentLevelPuzzles = (level - 1) * 10
        let nextLevelPuzzles = level * 10
        let progress = totalPuzzlesSolved - currentLevelPuzzles
        let required = nextLevelPuzzles - currentLevelPuzzles
        return Double(progress) / Double(required)
    }
}
