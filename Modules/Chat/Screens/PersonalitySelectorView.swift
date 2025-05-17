import SwiftUI

struct PersonalitySelectorView: View {
    @Binding var selected: Personality
    var onSelect: ((Personality) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Personality")
                .font(.headline)
            ForEach(Personality.allCases, id: \.self) { personality in
                HStack {
                    Text(personality.rawValue)
                        .fontWeight(selected == personality ? .bold : .regular)
                    Spacer()
                    if selected == personality {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selected = personality
                    onSelect?(personality)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// Preview
struct PersonalitySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalitySelectorView(selected: .constant(.default))
    }
}
