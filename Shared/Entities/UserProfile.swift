import Foundation

struct UserProfile: Identifiable, Codable {
    var id: UUID
    var name: String
    var preferredPersonality: Personality
    var enableNotifications: Bool
    var enableTaglish: Bool
    var customPrompt: String
    var lastMoodCheck: Date
    
    init(
        id: UUID = UUID(),
        name: String = "",
        preferredPersonality: Personality = .emotionalSupport,
        enableNotifications: Bool = true,
        enableTaglish: Bool = false,
        customPrompt: String = "",
        lastMoodCheck: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.preferredPersonality = preferredPersonality
        self.enableNotifications = enableNotifications
        self.enableTaglish = enableTaglish
        self.customPrompt = customPrompt
        self.lastMoodCheck = lastMoodCheck
    }
}
