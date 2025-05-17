import Foundation
import SwiftUI

@MainActor
class MoodTrackerPresenter: ObservableObject {
    @Published var moods: [EmotionEntry] = []
    @Published var selectedMood: EmotionEntry?
    @Published var showingMoodEntry = false
    @Published var newMoodNote = ""
    @Published var selectedTags: Set<String> = []
    
    private let user: UserProfile
    
    init(user: UserProfile) {
        self.user = user
        loadMoods()
    }
    
    func loadMoods() {
        // TODO: Load moods from persistent storage
        // For now, use sample data
        moods = [
            EmotionEntry(emoji: "😊", note: "Feeling great today!", tags: ["productive", "energetic"]),
            EmotionEntry(emoji: "😌", note: "Relaxed and content", tags: ["peaceful"]),
            EmotionEntry(emoji: "😔", note: "A bit down", tags: ["tired"])
        ]
    }
    
    func addMood(emoji: String) {
        let mood = EmotionEntry(
            emoji: emoji,
            note: newMoodNote,
            tags: Array(selectedTags)
        )
        moods.append(mood)
        newMoodNote = ""
        selectedTags.removeAll()
        showingMoodEntry = false
        
        // TODO: Save to persistent storage
        
        // Update last mood check
        user.lastMoodCheck = Date()
    }
    
    func deleteMood(_ mood: EmotionEntry) {
        moods.removeAll { $0.id == mood.id }
        // TODO: Save to persistent storage
    }
    
    func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    
    var moodStats: [String: Int] {
        var stats: [String: Int] = [:]
        for mood in moods {
            stats[mood.emoji, default: 0] += 1
        }
        return stats
    }
    
    var mostCommonMood: String? {
        moodStats.max(by: { $0.value < $1.value })?.key
    }
    
    var tagStats: [String: Int] {
        var stats: [String: Int] = [:]
        for mood in moods {
            for tag in mood.tags {
                stats[tag, default: 0] += 1
            }
        }
        return stats
    }
} 