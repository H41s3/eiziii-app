import SwiftUI

struct ChatScreen: View {
    @StateObject var viewModel: ChatPresenter
    
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
                PersonalitySelectorView(selected: $viewModel.selectedPersonality) { personality in
                    viewModel.changePersonality(personality)
                }
                .frame(width: 180)
                Spacer()
            }
            .padding(.horizontal)
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

// Preview
struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen(viewModel: ChatPresenter())
    }
}
