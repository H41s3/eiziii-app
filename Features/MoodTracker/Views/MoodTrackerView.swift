import SwiftUI

struct MoodTrackerView: View {
    @State private var selectedMood: String? = nil
    let moods = ["😊", "😌", "😐", "🥲", "😡", "🥶"]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("How are you feeling today?")
                .font(.title2)
                .padding(.top, 40)
            HStack(spacing: 24) {
                ForEach(moods, id: \ .self) { mood in
                    Button(action: { selectedMood = mood }) {
                        Text(mood)
                            .font(.system(size: 40))
                            .padding()
                            .background(selectedMood == mood ? Color.purple.opacity(0.2) : Color.clear)
                            .clipShape(Circle())
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct MoodTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        MoodTrackerView()
    }
}
