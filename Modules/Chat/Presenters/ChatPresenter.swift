import Foundation
import SwiftUI

@MainActor
class ChatPresenter: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var selectedPersonality: Personality = .emotionalSupport
    
    let user: UserProfile
    
    init(user: UserProfile) {
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
        do {
            let response = try await AIManager.shared.generateResponse(for: selectedPersonality, userInput: prompt)
            let aiMessage = ChatMessage(text: response, isUser: false)
            messages.append(aiMessage)
        } catch {
            let errorMsg = ChatMessage(text: "Sorry, I couldn't process your message.", isUser: false)
            messages.append(errorMsg)
        }
        isLoading = false
    }
    
    func changePersonality(_ personality: Personality) {
        selectedPersonality = personality
        user.preferredPersonality = personality
    }
}