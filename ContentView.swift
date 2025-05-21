import SwiftUI

struct ContentView: View {
    @StateObject private var user = UserProfile(
        name: "User",
        preferredPersonality: .emotionalSupport,
        enableNotifications: true,
        enableTaglish: false,
        customPrompt: "",
        lastMoodCheck: nil
    )
    
    var body: some View {
        TabView {
            ChatScreen(viewModel: ChatPresenter(user: user))
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
            
            MoodTrackerScreen(user: user)
                .tabItem {
                    Label("Mood", systemImage: "heart.fill")
                }
            
            RemindersView()
                .tabItem {
                    Label("Reminders", systemImage: "bell")
                }
            
            SettingsScreen(user: user)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}