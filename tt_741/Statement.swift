import Foundation

struct Statement: Identifiable, Codable, Hashable {
    let id: UUID
    let characterId: UUID
    let text: String
    let logicType: LogicType
    let references: [UUID]
    
    init(id: UUID = UUID(), characterId: UUID, text: String, logicType: LogicType = .simple, references: [UUID] = []) {
        self.id = id
        self.characterId = characterId
        self.text = text
        self.logicType = logicType
        self.references = references
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Statement, rhs: Statement) -> Bool {
        lhs.id == rhs.id
    }
}

enum LogicType: String, Codable, Hashable {
    case simple
    case negation
    case implication
    case biconditional
    case contradiction
}
