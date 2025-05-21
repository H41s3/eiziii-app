import SwiftUI

// MARK: - Main App
@main
struct EiziTestFile: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Content View
struct ContentView: View {
    @StateObject private var user = UserProfileModel()
    
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

// MARK: - Models
class UserProfileModel: ObservableObject {
    @Published var id = UUID()
    @Published var name: String = "User"
    @Published var preferredPersonality: Personality = .emotionalSupport
    @Published var enableNotifications: Bool = true
    @Published var enableTaglish: Bool = false
    @Published var customPrompt: String = ""
    @Published var lastMoodCheck: Date? = nil
}

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

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let text: String
    let isUser: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), text: String, isUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.isUser = isUser
        self.timestamp = timestamp
    }
}

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

// MARK: - View Models
@MainActor
class ChatPresenter: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var selectedPersonality: Personality
    
    let user: UserProfileModel
    
    init(user: UserProfileModel) {
        self.user = user
        self.selectedPersonality = user.preferredPersonality
    }
    
    func sendMessage() async {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let userMessage = ChatMessage(text: inputText, isUser: true)
        messages.append(userMessage)
        let prompt = inputText
        inputText = ""
        isLoading = true
        
        // Simulate AI response
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        let response = "I understand how you feel. Would you like to talk more about it?"
        let aiMessage = ChatMessage(text: response, isUser: false)
        messages.append(aiMessage)
        isLoading = false
    }
    
    func changePersonality(_ personality: Personality) {
        selectedPersonality = personality
        user.preferredPersonality = personality
    }
}

@MainActor
class MoodTrackerPresenter: ObservableObject {
    @Published var moods: [EmotionEntry] = []
    @Published var showingMoodEntry = false
    @Published var newMoodNote = ""
    @Published var selectedTags: Set<String> = []
    
    private let user: UserProfileModel
    
    init(user: UserProfileModel) {
        self.user = user
        loadMoods()
    }
    
    func loadMoods() {
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
        user.lastMoodCheck = Date()
    }
    
    func deleteMood(_ mood: EmotionEntry) {
        moods.removeAll { $0.id == mood.id }
    }
    
    func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    
    var mostCommonMood: String? {
        var stats: [String: Int] = [:]
        for mood in moods {
            stats[mood.emoji, default: 0] += 1
        }
        return stats.max(by: { $0.value < $1.value })?.key
    }
}

@MainActor
class SettingsPresenter: ObservableObject {
    @Published var user: UserProfileModel
    @Published var showingNameEdit = false
    @Published var newName = ""
    
    init(user: UserProfileModel) {
        self.user = user
        self.newName = user.name
    }
    
    func updateName() {
        user.name = newName
        showingNameEdit = false
    }
    
    func toggleNotifications() {
        user.enableNotifications.toggle()
    }
    
    func toggleTaglish() {
        user.enableTaglish.toggle()
    }
    
    func updateCustomPrompt() {
    }
    
    func updatePersonality(_ personality: Personality) {
        user.preferredPersonality = personality
    }
}

// MARK: - Views
struct ChatScreen: View {
    @ObservedObject var viewModel: ChatPresenter
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            HStack(alignment: .bottom) {
                                if message.isUser { Spacer() }
                                VStack(alignment: message.isUser ? .trailing : .leading) {
                                    Text(message.text)
                                        .padding(10)
                                        .background(message.isUser ? Color.accentColor.opacity(0.2) : Color(.systemGray5))
                                        .cornerRadius(12)
                                        .foregroundColor(.primary)
                                    Text(message.timestamp, style: .time)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                if !message.isUser { Spacer() }
                            }
                            .id(message.id)
                        }
                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                Text("Eizi is thinking...")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let last = viewModel.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
            Divider()
            HStack {
                TextField("Type a message...", text: $viewModel.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(viewModel.isLoading)
                Button(action: {
                    Task { await viewModel.sendMessage() }
                }) {
                    Image(systemName: "paperplane.fill")
                        .rotationEffect(.degrees(45))
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
            }
            .padding()
        }
        .navigationTitle("Eizi Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MoodTrackerScreen: View {
    @StateObject private var presenter: MoodTrackerPresenter
    
    init(user: UserProfileModel) {
        _presenter = StateObject(wrappedValue: MoodTrackerPresenter(user: user))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let mostCommonMood = presenter.mostCommonMood {
                    VStack {
                        Text("Most Common Mood")
                            .font(.headline)
                        Text(mostCommonMood)
                            .font(.system(size: 50))
                    }
                    .padding()
                }
                
                List {
                    ForEach(presenter.moods) { mood in
                        MoodEntryRow(mood: mood)
                            .swipeActions {
                                Button(role: .destructive) {
                                    presenter.deleteMood(mood)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .navigationTitle("Mood Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presenter.showingMoodEntry = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $presenter.showingMoodEntry) {
                MoodEntryView(presenter: presenter)
            }
        }
    }
}

struct MoodEntryRow: View {
    let mood: EmotionEntry
    
    var body: some View {
        HStack {
            Text(mood.emoji)
                .font(.system(size: 30))
            
            VStack(alignment: .leading) {
                if let note = mood.note {
                    Text(note)
                        .font(.body)
                }
                
                if !mood.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(mood.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            Text(mood.timestamp, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct MoodEntryView: View {
    @ObservedObject var presenter: MoodTrackerPresenter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("How are you feeling?") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        ForEach(EmotionEntry.moodOptions, id: \.self) { emoji in
                            Button {
                                presenter.addMood(emoji: emoji)
                                dismiss()
                            } label: {
                                Text(emoji)
                                    .font(.system(size: 40))
                            }
                        }
                    }
                    .padding()
                }
                
                Section("Add a note (optional)") {
                    TextEditor(text: $presenter.newMoodNote)
                        .frame(height: 100)
                }
                
                Section("Tags") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(EmotionEntry.moodCategories, id: \.self) { tag in
                                Button {
                                    presenter.toggleTag(tag)
                                } label: {
                                    Text(tag)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(presenter.selectedTags.contains(tag) ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(presenter.selectedTags.contains(tag) ? .white : .primary)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Mood Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct RemindersView: View {
    var body: some View {
        VStack {
            Text("Reminders coming soon!")
                .font(.title2)
                .padding()
            Spacer()
        }
    }
}

struct SettingsScreen: View {
    @StateObject private var presenter: SettingsPresenter
    
    init(user: UserProfileModel) {
        _presenter = StateObject(wrappedValue: SettingsPresenter(user: user))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile") {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(presenter.user.name)
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        presenter.showingNameEdit = true
                    }
                }
                
                Section("AI Preferences") {
                    Picker("Personality", selection: $presenter.user.preferredPersonality) {
                        ForEach(Personality.allCases, id: \.self) { personality in
                            Text(personality.description)
                                .tag(personality)
                        }
                    }
                    
                    Toggle("Enable Taglish", isOn: $presenter.user.enableTaglish)
                        .onChange(of: presenter.user.enableTaglish) { _ in
                            presenter.toggleTaglish()
                        }
                    
                    TextField("Custom Prompt", text: $presenter.user.customPrompt)
                        .onChange(of: presenter.user.customPrompt) { _ in
                            presenter.updateCustomPrompt()
                        }
                }
                
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $presenter.user.enableNotifications)
                        .onChange(of: presenter.user.enableNotifications) { _ in
                            presenter.toggleNotifications()
                        }
                }
            }
            .navigationTitle("Settings")
            .alert("Edit Name", isPresented: $presenter.showingNameEdit) {
                TextField("Name", text: $presenter.newName)
                Button("Cancel", role: .cancel) { }
                Button("Save") {
                    presenter.updateName()
                }
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}