import Foundation
import SwiftUI

struct Character: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let avatarColor: String
    let role: String
    
    init(id: UUID = UUID(), name: String, avatarColor: String, role: String = "") {
        self.id = id
        self.name = name
        self.avatarColor = avatarColor
        self.role = role
    }
    
    var color: Color {
        Color(hex: avatarColor)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}
