import SwiftUI

@main
struct EiziiiApp: App {
    @StateObject private var user = UserProfile(
        name: "User",
        preferredPersonality: .emotionalSupport,
        enableNotifications: true,
        enableTaglish: false,
        customPrompt: "",
        lastMoodCheck: nil
    )
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ChatScreen(user: user)
                    .tabItem {
                        Label("Chat", systemImage: "message.fill")
                    }
                
                MoodTrackerScreen(user: user)
                    .tabItem {
                        Label("Mood", systemImage: "heart.fill")
                    }
                
                SettingsScreen(user: user)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
} 