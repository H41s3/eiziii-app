import SwiftUI

struct SettingsScreen: View {
    @StateObject private var presenter: SettingsPresenter
    
    init(user: UserProfile) {
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