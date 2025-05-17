# Eiziii

Eiziii is an emotional companion iOS app designed to support users through chat, mood tracking, and reminders. Built with SwiftUI and a modular architecture, Eiziii offers a clean, scalable foundation for future growth and feature expansion.

## Features
- **Chat with Eiziii**: AI-powered chat with multiple personalities (Emotional Support, Intellectual Sparring, Tech Mentor)
- **Mood Tracker**: Log your daily moods, add notes, and view mood history
- **Reminders**: Set reminders for mood check-ins and self-care
- **Settings**: Personalize your experience, choose AI personality, and manage preferences

## Folder Structure
```
Eiziii/                # Main app entry point
Modules/
  Chat/                # Chat feature (screens, presenters)
  MoodTracker/         # Mood tracking feature
  Reminders/           # Reminders feature
  Settings/            # Settings feature
Shared/
  Entities/            # Shared models (UserProfile, ChatMessage, etc.)
  Managers/            # Shared services (AIManager, NotificationManager)
Resources/             # Assets, LaunchScreen, etc.
```

## Getting Started
1. **Clone the repository:**
   ```bash
   git clone https://github.com/H41s3/eiziii-app.git
   cd eiziii-app
   ```
2. **Open in Xcode:**
   - Open `Eiziii.xcodeproj` or `Eiziii.xcworkspace` in Xcode.
3. **Build and run:**
   - Select a simulator and press `Cmd+R` to build and run the app.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a pull request

## License
[MIT](LICENSE) 