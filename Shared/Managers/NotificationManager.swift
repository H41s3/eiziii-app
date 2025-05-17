import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        return try await center.requestAuthorization(options: options)
    }
    
    func scheduleMoodCheck(for user: UserProfile) {
        let content = UNMutableNotificationContent()
        content.title = "Time for a Mood Check"
        content.body = "How are you feeling today?"
        content.sound = .default
        
        // Schedule for 9 PM daily
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "moodCheck", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleCustomReminder(for user: UserProfile, message: String, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder from Eizi"
        content.body = message
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
