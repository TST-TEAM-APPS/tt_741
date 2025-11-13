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
    
    private var cancellables = Set<AnyCancellable>()
    let logicEvaluator = LogicEvaluator()
    let puzzleGenerator = LogicBuilder()
    
    init() {
        self.userProgress = UserProgress.load()
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
