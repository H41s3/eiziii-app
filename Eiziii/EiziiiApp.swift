import SwiftUI

@main
struct EiziiiApp: App {
    @StateObject private var chatViewModel = ChatViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    ChatView(viewModel: chatViewModel)
                }
                .tabItem {
                    Label("Chat", systemImage: "bubble.left.and.bubble.right")
                }
                
                NavigationStack {
                    MoodTrackerView()
                }
                .tabItem {
                    Label("Mood Tracker", systemImage: "face.smiling")
                }
                
                NavigationStack {
                    RemindersView()
                }
                .tabItem {
                    Label("Reminders", systemImage: "bell")
                }
            }
        }
    }
} 