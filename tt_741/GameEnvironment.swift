import SwiftUI
import Combine

class GameEnvironment: ObservableObject {
    @Published var currentPuzzle: Puzzle?
    @Published var userProgress: UserProgress
    @Published var selectedAnswers: [String: Bool] = [:]
    @Published var showResult = false
    @Published var isCorrect = false
    @Published var explanation: [LogicStep] = []
    @Published var marathonScore = 0
    @Published var marathonActive = false
    @Published var dailyStreak = 0
    @Published var showDailyReward = false
    
    private var cancellables = Set<AnyCancellable>()
    let logicEvaluator = LogicEvaluator()
    let puzzleGenerator = LogicBuilder()
    
    init() {
        self.userProgress = UserProgress.load()
        self.dailyStreak = calculateDailyStreak()
        checkDailyReward()
    }
    
    func startNewPuzzle(difficulty: Difficulty, mode: GameMode) {
        selectedAnswers.removeAll()
        showResult = false
        isCorrect = false
        explanation.removeAll()
        
        if mode == .marathon && !marathonActive {
            marathonActive = true
            marathonScore = 0
        }
        
        currentPuzzle = puzzleGenerator.generate(difficulty: difficulty, basedOn: userProgress)
    }
    
    func submitAnswer() {
        guard let puzzle = currentPuzzle else { return }
        
        let result = logicEvaluator.evaluate(puzzle: puzzle, answers: selectedAnswers)
        isCorrect = result.isCorrect
        explanation = result.steps
        showResult = true
        
        if isCorrect {
            userProgress.recordSuccess(puzzle: puzzle)
            if marathonActive {
                marathonScore += 1
                userProgress.updateMarathonScore(marathonScore)
            }
            updateDailyProgress()
        } else {
            userProgress.recordFailure(puzzle: puzzle)
            if marathonActive {
                marathonActive = false
            }
        }
        
        userProgress.save()
        
        triggerHaptic(isCorrect ? .success : .error)
    }
    
    func resetGame() {
        currentPuzzle = nil
        selectedAnswers.removeAll()
        showResult = false
        isCorrect = false
        explanation.removeAll()
        marathonActive = false
        marathonScore = 0
    }
    
    private func calculateDailyStreak() -> Int {
        guard let lastPlayed = userProgress.lastPlayedDate else { return 0 }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastPlayedDay = calendar.startOfDay(for: lastPlayed)
        
        let daysDifference = calendar.dateComponents([.day], from: lastPlayedDay, to: today).day ?? 0
        
        if daysDifference == 0 {
            return userProgress.dailyStreak
        } else if daysDifference == 1 {
            return userProgress.dailyStreak
        } else {
            return 0
        }
    }
    
    private func updateDailyProgress() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastPlayed = userProgress.lastPlayedDate {
            let lastPlayedDay = calendar.startOfDay(for: lastPlayed)
            let daysDifference = calendar.dateComponents([.day], from: lastPlayedDay, to: today).day ?? 0
            
            if daysDifference == 1 {
                userProgress.dailyStreak += 1
                dailyStreak = userProgress.dailyStreak
                if userProgress.dailyStreak % 7 == 0 {
                    showDailyReward = true
                }
            } else if daysDifference > 1 {
                userProgress.dailyStreak = 1
                dailyStreak = 1
            }
        } else {
            userProgress.dailyStreak = 1
            dailyStreak = 1
        }
        
        userProgress.save()
    }
    
    private func checkDailyReward() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastPlayed = userProgress.lastPlayedDate {
            let lastPlayedDay = calendar.startOfDay(for: lastPlayed)
            let daysDifference = calendar.dateComponents([.day], from: lastPlayedDay, to: today).day ?? 0
            
            if daysDifference >= 1 && userProgress.dailyStreak > 0 {
                showDailyReward = true
            }
        }
    }
    
    private func triggerHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

enum GameMode {
    case classic
    case marathon
    case generator
    case tutorial
}
