import SwiftUI

struct PersonalitySelectorView: View {
    let personalities = Personality.allCases
    var onSelect: (Personality) -> Void
    
    var body: some View {
        List(personalities) { personality in
            Button(action: { onSelect(personality) }) {
                HStack {
                    Text(personality.displayName)
                    Spacer()
                }
            }
        }
        .navigationTitle("Select Personality")
    }
}

// Preview
struct PersonalitySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalitySelectorView { _ in }
    }
}
