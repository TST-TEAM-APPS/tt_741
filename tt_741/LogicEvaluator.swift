import Foundation

class LogicEvaluator {
    func evaluate(puzzle: Puzzle, answers: [String: Bool]) -> EvaluationResult {
        let isCorrect = puzzle.solution.isCorrect(answers: answers)
        let steps = generateExplanation(puzzle: puzzle, isCorrect: isCorrect)
        
        return EvaluationResult(isCorrect: isCorrect, steps: steps)
    }
    
    private func generateExplanation(puzzle: Puzzle, isCorrect: Bool) -> [LogicStep] {
        var steps: [LogicStep] = []
        
        steps.append(LogicStep(
            step: 1,
            description: "Analyzing statements",
            affectedCharacters: puzzle.characters.map { $0.id },
            conclusion: "Checking logical consistency"
        ))
        
        for (index, character) in puzzle.characters.enumerated() {
            let isTruthTeller = puzzle.solution.truthTellers.contains(character.id)
            let statement = puzzle.statements.first { $0.characterId == character.id }
            
            steps.append(LogicStep(
                step: index + 2,
                description: "\(character.name) says: \"\(statement?.text ?? "")\"",
                affectedCharacters: [character.id],
                conclusion: isTruthTeller ? "\(character.name) tells the truth" : "\(character.name) lies"
            ))
        }
        
        steps.append(LogicStep(
            step: steps.count + 1,
            description: "Verification",
            affectedCharacters: [],
            conclusion: isCorrect ? "All constraints satisfied!" : "Contradiction found"
        ))
        
        return steps
    }
}

struct EvaluationResult {
    let isCorrect: Bool
    let steps: [LogicStep]
}
