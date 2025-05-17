import Foundation

enum Personality: String, CaseIterable, Codable {
    case emotionalSupport = "Emotional Support"
    case intellectualSparring = "Intellectual Sparring"
    case techMentor = "Tech Mentor"
    
    var description: String {
        switch self {
        case .emotionalSupport:
            return "A caring and empathetic companion who provides emotional support and understanding."
        case .intellectualSparring:
            return "A thought-provoking partner who challenges your ideas and helps you think deeper."
        case .techMentor:
            return "A knowledgeable guide who helps you learn and grow in your technical journey."
        }
    }
}
