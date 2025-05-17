import SwiftUI

struct MoodTrackerView: View {
    @StateObject var viewModel: MoodTrackerViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.moods) { mood in
                        HStack {
                            Text(mood.emoji)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(mood.note ?? "No note")
                                    .font(.body)
                                Text(mood.timestamp, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                if !mood.tags.isEmpty {
                                    Text(mood.tags.joined(separator: ", "))
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let mood = viewModel.moods[index]
                            viewModel.deleteMood(mood)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                Button(action: { viewModel.showingMoodEntry = true }) {
                    Label("Add Mood", systemImage: "plus")
                }
                .padding()
            }
            .navigationTitle("Mood Tracker")
            .sheet(isPresented: $viewModel.showingMoodEntry) {
                MoodEntrySheet(viewModel: viewModel)
            }
        }
    }
}

struct MoodEntrySheet: View {
    @ObservedObject var viewModel: MoodTrackerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEmoji: String = "😊"
    
    var body: some View {
        NavigationView {
            Form {
                Section("Mood") {
                    Picker("Emoji", selection: $selectedEmoji) {
                        ForEach(Mood.moodOptions, id: \.self) { emoji in
                            Text(emoji)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                Section("Note") {
                    TextField("How are you feeling?", text: $viewModel.newMoodNote)
                }
                Section("Tags") {
                    ForEach(Mood.moodCategories, id: \.self) { tag in
                        Button(action: { viewModel.toggleTag(tag) }) {
                            HStack {
                                Text(tag)
                                Spacer()
                                if viewModel.selectedTags.contains(tag) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("New Mood Entry")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addMood(emoji: selectedEmoji)
                        dismiss()
                    }
                    .disabled(viewModel.newMoodNote.isEmpty)
                }
            }
        }
    }
}

struct MoodTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        MoodTrackerView(viewModel: MoodTrackerViewModel())
    }
}
