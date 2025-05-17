import Foundation

struct EmotionEntry: Identifiable, Codable {
    let id: UUID
    let emoji: String
    let note: String?
    let timestamp: Date
    let tags: [String]
    
    init(id: UUID = UUID(), emoji: String, note: String? = nil, timestamp: Date = Date(), tags: [String] = []) {
        self.id = id
        self.emoji = emoji
        self.note = note
        self.timestamp = timestamp
        self.tags = tags
    }
    
    static let moodOptions = ["😊", "😌", "😐", "😔", "😡", "😴"]
    static let moodCategories = ["productive", "energetic", "peaceful", "tired", "stressed", "happy", "sad"]
}
