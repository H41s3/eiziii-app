import Foundation

enum Personality: String, Codable, CaseIterable, Identifiable {
    case emotionalSupport
    case intellectualSparring
    case techMentor
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .emotionalSupport: return "Emotional Support"
        case .intellectualSparring: return "Intellectual Sparring"
        case .techMentor: return "Tech Mentor"
        }
    }
}
