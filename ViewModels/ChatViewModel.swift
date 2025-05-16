import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = [
        Message(id: UUID(), text: "Hey there! 👋 I'm Eizi, your emotional support companion. I'm here to listen, understand, and support you through your journey.", isUser: false, timestamp: Date())
    ]
    @Published var inputText: String = ""
    @Published var selectedPersonality: Personality = .emotionalSupport
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let userMessage = Message(id: UUID(), text: inputText, isUser: true, timestamp: Date())
        messages.append(userMessage)
        let personality = selectedPersonality
        let userInput = inputText
        inputText = ""
        // Simulate AI response based on personality
        let responseText = generateResponse(for: personality, userInput: userInput)
        let aiMessage = Message(id: UUID(), text: responseText, isUser: false, timestamp: Date())
        messages.append(aiMessage)
    }
    
    private func generateResponse(for personality: Personality, userInput: String) -> String {
        switch personality {
        case .emotionalSupport:
            return "I'm here for you. Remember, it's okay to feel this way. Want to talk more about it?"
        case .intellectualSparring:
            return "Interesting point! But have you considered the opposite perspective? Let's dig deeper."
        case .techMentor:
            return "Great question! Let's break it down step by step. Where do you want to start?"
        }
    }
    
    func showPersonalitySelector() {
        // TODO: Implement personality selector presentation
    }
}
