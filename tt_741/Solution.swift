import Foundation

struct Solution: Codable, Hashable {
    let truthTellers: [UUID]
    let liars: [UUID]
    let reasoning: String
    
    func isCorrect(answers: [String: Bool]) -> Bool {
        var correct = true
        
        for (charId, isTruthTeller) in answers {
            guard let uuid = UUID(uuidString: charId) else { continue }
            
            if isTruthTeller && !truthTellers.contains(uuid) {
                correct = false
            }
            if !isTruthTeller && !liars.contains(uuid) {
                correct = false
            }
        }
        
        return correct && answers.count == (truthTellers.count + liars.count)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(truthTellers)
        hasher.combine(liars)
    }
    
    static func == (lhs: Solution, rhs: Solution) -> Bool {
        lhs.truthTellers == rhs.truthTellers && lhs.liars == rhs.liars
    }
}

struct LogicStep: Identifiable, Hashable {
    let id = UUID()
    let step: Int
    let description: String
    let affectedCharacters: [UUID]
    let conclusion: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: LogicStep, rhs: LogicStep) -> Bool {
        lhs.id == rhs.id
    }
}
