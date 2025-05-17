import SwiftUI

struct MoodTrackerScreen: View {
    @StateObject private var presenter: MoodTrackerPresenter
    
    init(user: UserProfile) {
        _presenter = StateObject(wrappedValue: MoodTrackerPresenter(user: user))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Mood Stats
                if let mostCommonMood = presenter.mostCommonMood {
                    VStack {
                        Text("Most Common Mood")
                            .font(.headline)
                        Text(mostCommonMood)
                            .font(.system(size: 50))
                    }
                    .padding()
                }
                
                // Mood History
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