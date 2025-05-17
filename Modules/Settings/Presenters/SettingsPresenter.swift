import Foundation
import SwiftUI

@MainActor
class SettingsPresenter: ObservableObject {
    @Published var user: UserProfile
    @Published var showingNameEdit = false
    @Published var newName = ""
    
    init(user: UserProfile) {
        self.user = user
        self.newName = user.name
    }
    
    func updateName() {
        user.name = newName
        // TODO: Save to persistent storage
        showingNameEdit = false
    }
    
    func toggleNotifications() {
        user.enableNotifications.toggle()
        if user.enableNotifications {
            NotificationManager.shared.requestAuthorization()
            NotificationManager.shared.scheduleMoodCheck(for: user)
        } else {
            NotificationManager.shared.cancelAllNotifications()
        }
        // TODO: Save to persistent storage
    }
    
    func toggleTaglish() {
        user.enableTaglish.toggle()
        // TODO: Save to persistent storage
    }
    
    func updateCustomPrompt() {
        // TODO: Save to persistent storage
    }
    
    func updatePersonality(_ personality: Personality) {
        user.preferredPersonality = personality
        // TODO: Save to persistent storage
    }
} 