import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var showingPersonalitySelector = false
    
    var body: some View {
        VStack {
            // Personality Mode Display
            HStack {
                Text("Personality: \(viewModel.selectedPersonality.displayName)")
                    .font(.headline)
                Spacer()
                Button(action: { showingPersonalitySelector = true }) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                }
            }
            .padding()
            
            // Messages List
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.messages) { message in
                        HStack(alignment: .top) {
                            if message.isUser {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.purple.opacity(0.2))
                                    .cornerRadius(12)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Input Field
            HStack {
                TextField("Type a message...", text: $viewModel.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    viewModel.sendMessage()
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.leading, 4)
            }
            .padding()
        }
        .sheet(isPresented: $showingPersonalitySelector) {
            PersonalitySelectorView { selected in
                viewModel.selectedPersonality = selected
                showingPersonalitySelector = false
            }
        }
    }
}

// Preview
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(viewModel: ChatViewModel())
    }
}
