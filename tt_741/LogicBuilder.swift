import Foundation

class LogicBuilder {
    private let templates: [PuzzleTemplate]
    private let names = ["Alex", "Blake", "Casey", "Drew", "Eden", "Finn", "Grey", "Harper"]
    private let colors = ["FF3B30", "FF9500", "FFCC00", "34C759", "007AFF", "5856D6", "AF52DE", "FF2D55"]
    
    init() {
        self.templates = Self.loadTemplates()
    }
    
    func generate(difficulty: Difficulty, basedOn progress: UserProgress) -> Puzzle {
        let charCount = Int.random(in: difficulty.characterCount)
        let type = selectType(basedOn: progress)
        
        let characters = generateCharacters(count: charCount)
        let (statements, solution) = generateLogic(characters: characters, type: type, difficulty: difficulty)
        
        return Puzzle(
            title: type.rawValue,
            difficulty: difficulty,
            type: type,
            characters: characters,
            statements: statements,
            solution: solution
        )
    }
    
    private func generateCharacters(count: Int) -> [Character] {
        let shuffledNames = names.shuffled()
        let shuffledColors = colors.shuffled()
        
        return (0..<count).map { index in
            Character(
                name: shuffledNames[index],
                avatarColor: shuffledColors[index]
            )
        }
    }
    
    private func generateLogic(characters: [Character], type: PuzzleType, difficulty: Difficulty) -> ([Statement], Solution) {
        let truthTellerCount: Int
        
        switch type {
        case .onlyOneTruth:
            truthTellerCount = 1
        case .allButOneLie:
            truthTellerCount = characters.count - 1
        case .whoIsGuilty, .conditional:
            truthTellerCount = Int.random(in: 1...max(1, characters.count - 1))
        }
        
        let truthTellers = Array(characters.shuffled().prefix(truthTellerCount))
        let liars = characters.filter { char in
            !truthTellers.contains(where: { $0.id == char.id })
        }
        
        var statements: [Statement] = []
        
        for character in characters {
            let isTruthTeller = truthTellers.contains(where: { $0.id == character.id })
            let statement = generateStatement(
                for: character,
                isTruthTeller: isTruthTeller,
                allCharacters: characters,
                truthTellers: truthTellers,
                difficulty: difficulty
            )
            statements.append(statement)
        }
        
        let solution = Solution(
            truthTellers: truthTellers.map { $0.id },
            liars: liars.map { $0.id },
            reasoning: "Based on logical deduction"
        )
        
        return (statements, solution)
    }
    
    private func generateStatement(for character: Character, isTruthTeller: Bool, allCharacters: [Character], truthTellers: [Character], difficulty: Difficulty) -> Statement {
        let others = allCharacters.filter { $0.id != character.id }
        
        guard let target = others.randomElement() else {
            return Statement(
                characterId: character.id,
                text: "I always tell the truth",
                logicType: .simple
            )
        }
        
        let targetIsTruthTeller = truthTellers.contains(where: { $0.id == target.id })
        
        let templates: [String]
        if isTruthTeller {
            templates = targetIsTruthTeller ?
                ["\(target.name) tells the truth", "\(target.name) is honest", "I trust \(target.name)"] :
                ["\(target.name) is lying", "\(target.name) is not trustworthy", "\(target.name) deceives us"]
        } else {
            templates = targetIsTruthTeller ?
                ["\(target.name) is lying", "\(target.name) cannot be trusted", "\(target.name) is a liar"] :
                ["\(target.name) tells the truth", "\(target.name) is honest", "I agree with \(target.name)"]
        }
        
        let text = templates.randomElement() ?? "I tell the truth"
        
        return Statement(
            characterId: character.id,
            text: text,
            logicType: difficulty == .sage ? .implication : .simple,
            references: [target.id]
        )
    }
    
    private func selectType(basedOn progress: UserProgress) -> PuzzleType {
        if progress.totalPuzzlesSolved < 3 {
            return .onlyOneTruth
        }
        
        return PuzzleType.allCases.randomElement() ?? .onlyOneTruth
    }
    
    private static func loadTemplates() -> [PuzzleTemplate] {
        return []
    }
}

struct PuzzleTemplate: Codable {
    let type: PuzzleType
    let difficulty: Difficulty
    let structure: String
}
