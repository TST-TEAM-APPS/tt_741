import Foundation

class ConsistencyChecker {
    func check(puzzle: Puzzle) -> Bool {
        let truthCount = puzzle.solution.truthTellers.count
        let liarCount = puzzle.solution.liars.count
        let totalChars = puzzle.characters.count
        
        guard truthCount + liarCount == totalChars else { return false }
        
        switch puzzle.type {
        case .onlyOneTruth:
            return truthCount == 1
        case .allButOneLie:
            return liarCount == 1
        case .whoIsGuilty, .conditional:
            return truthCount >= 1
        }
    }
    
    func validateStatements(puzzle: Puzzle) -> Bool {
        for statement in puzzle.statements {
            guard puzzle.characters.contains(where: { $0.id == statement.characterId }) else {
                return false
            }
            
            for refId in statement.references {
                guard puzzle.characters.contains(where: { $0.id == refId }) else {
                    return false
                }
            }
        }
        
        return true
    }
}
