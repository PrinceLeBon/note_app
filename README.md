# Note App 📝

A modern, feature-rich note-taking application built with Flutter and Firebase. This app combines elegant design with powerful functionality, allowing users to organize their thoughts efficiently with hashtags and real-time search capabilities.

> Design inspired by [this Dribbble concept](https://dribbble.com/shots/11875872-A-simple-and-lightweight-note-app)  
> App icon by [Jocularityart](https://www.flaticon.com/fr/sticker-gratuite/note-collante_6558596?term=note&page=1&position=5&origin=search&related_id=6558596)

## 📱 Screenshots

*[Add your app screenshots here]*

## ✨ Key Features

### User Management
- **Secure Authentication**: Email/password registration and login via Firebase Auth
- **User Profiles**: Personal profiles with photo upload capability
- **Session Management**: Secure logout functionality

### Note Management
- **Create & Delete**: Full CRUD operations for notes (create, read, delete)
- **Flexible Creation**: Notes can be created without title, content, or hashtags
- **Swipe Actions**: Intuitive swipe-to-delete functionality
- **Timestamp Sorting**: Automatic sorting by creation date (newest first)

### Organization & Search
- **Hashtag System**: Create custom hashtags with personalized colors
- **Smart Filtering**: Filter notes by hashtags or keywords
- **Real-time Search**: Instant search through note titles and content
- **Color Coding**: Visual organization with custom color picker for hashtags

### Offline Capabilities
- **Local Storage**: Hive database for offline data persistence
- **Offline Mode**: Full functionality without internet connection
- **Auto-sync**: Seamless synchronization with Firebase when online

## 🛠 Tech Stack

### Frontend
- **Framework**: Flutter (Dart)
- **State Management**: BLoC Pattern (flutter_bloc)
- **UI Components**: Material Design with custom theming
- **Local Database**: Hive

### Backend
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage
- **Platform**: Cross-platform (iOS, Android, Web, Desktop)

## 📦 Key Dependencies

```yaml
# State Management
bloc: ^9.0.0
flutter_bloc: ^9.1.1

# Firebase Services
firebase_core: ^3.14.0
cloud_firestore: ^5.6.9
firebase_storage: ^12.4.7
firebase_auth: ^5.6.0

# Local Storage
hive: ^2.2.3
hive_flutter: ^1.1.0

# UI Components
flutter_colorpicker: ^1.1.0
flutter_slidable: ^4.0.0
google_fonts: ^6.2.1
flutter_spinkit: ^5.2.1

# Utilities
cached_network_image: ^3.4.1
image_picker: ^1.1.2
flutter_linkify: ^6.0.0
url_launcher: latest
intl: ^0.20.2
logger: ^2.5.0
```

## 🏗 Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── business_logic/          # Business Logic Layer
│   └── cubit/              # State Management (BLoC/Cubit)
│       ├── hashtags/       # Hashtag state management
│       ├── notes/          # Note state management
│       └── users/          # User state management
│
├── data/                   # Data Layer
│   ├── models/            # Data Models
│   │   ├── note.dart      # Note model with Hive adapters
│   │   ├── hashtag.dart   # HashTag model
│   │   └── user.dart      # User model
│   ├── providers/         # External Data Sources
│   │   └── firestore.dart # Firebase API provider
│   └── repositories/      # Repository Pattern Implementation
│       ├── note.dart      # Note repository
│       ├── hashtag.dart   # Hashtag repository
│       └── user.dart      # User repository
│
├── presentation/          # Presentation Layer
│   ├── screens/          # App Screens
│   │   ├── connexion/    # Authentication screens
│   │   ├── homepage.dart # Main dashboard
│   │   ├── new_note.dart # Note creation screen
│   │   └── ...          # Other screens
│   └── widgets/         # Reusable UI Components
│       ├── custom_drawer.dart
│       ├── custom_text_field.dart
│       ├── hashtags.dart
│       └── ...          # Other widgets
│
└── utils/               # Utilities & Constants
    └── constants.dart   # App-wide constants
```

### Design Patterns

1. **Repository Pattern**: Abstracts data sources and provides clean API for data access
2. **BLoC Pattern**: Separates business logic from presentation layer
3. **Dependency Injection**: Uses Provider pattern for dependency management
4. **Clean Architecture**: Ensures testability, scalability, and maintainability

## 🎨 UI/UX Design

- **Theme**: Dark mode with minimalist design
- **Color Scheme**: 
  - Primary: Black (#131313)
  - Secondary: White
  - Accent: Custom colors for hashtags
- **Typography**: Google Fonts integration
- **Responsive Design**: Adapts to various screen sizes
- **Material Design**: Following Google's design guidelines

## 🚀 Installation

### Prerequisites
- Flutter SDK (>=2.19.6 <3.0.0)
- Dart SDK
- Firebase account
- Android Studio / Xcode (for mobile development)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/note_app.git
   cd note_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   - Create a new Firebase project
   - Add Android/iOS apps in Firebase console
   - Download and add configuration files:
     - `google-services.json` for Android (place in `android/app/`)
     - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
   - Enable Authentication, Firestore, and Storage in Firebase console

4. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## 📖 Usage Guide

### Getting Started
1. **Create an Account**: Register with email and password
2. **Set Up Profile**: Add your name and profile photo
3. **Create Your First Note**: Tap the "+" button to start

### Managing Notes
1. **Add Notes**: Use the floating action button (+) to create new notes
2. **Add Hashtags**: Create custom hashtags with colors while creating notes
3. **Search Notes**: Use the search icon to find notes by keywords
4. **Filter by Hashtags**: Select hashtags to filter your notes
5. **Delete Notes**: Swipe left on any note to delete it

### Organization Tips
- Use hashtags to categorize your notes
- Assign unique colors to different categories
- Use the search function for quick access to specific notes

## 📊 Data Models

### Note Model
```dart
class Note {
  String id;
  List<String> hashtagsId;
  String userId;
  String title;
  String note;
  DateTime creationDate;
}
```

### HashTag Model
```dart
class HashTag {
  String id;
  String label;
  String color;
  DateTime creationDate;
  String userId;
}
```

### User Model
```dart
class UserModel {
  String id;
  String nom;     // Last name
  String prenom;  // First name
  String email;
  String photo;
}
```

## 🔐 Security Features

- **Firebase Authentication**: Secure user authentication
- **User Data Isolation**: Each user can only access their own notes
- **Secure Storage**: Profile photos stored in Firebase Storage
- **Session Management**: Automatic session handling

## 🌐 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 🧪 Testing

Run the tests with:
```bash
flutter test
```

## 🔧 Development Tools

### Code Generation
Generate Hive adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### App Icons
Generate app icons:
```bash
flutter pub run flutter_launcher_icons
```

## 📱 Minimum Requirements

### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: Latest stable

### iOS
- Minimum iOS version: 11.0
- Xcode: Latest stable

## 🚦 Project Status

The project is actively maintained and open for contributions.

## 🔮 Future Enhancements

### Short-term Goals
- [ ] **Edit Notes**: Allow users to update existing notes
- [ ] **Manage Hashtags**: Update and delete hashtags functionality
- [ ] **Profile Management**: Complete profile update features
- [ ] **Enhanced Offline Sync**: Improved conflict resolution for offline changes

### Long-term Vision
- [ ] **Rich Text Editor**: Support for formatted text, lists, and links
- [ ] **Note Sharing**: Share notes with other users
- [ ] **Dark/Light Theme**: Theme switcher
- [ ] **Export Options**: Export notes as PDF, TXT, or Markdown
- [ ] **Voice Notes**: Audio recording support
- [ ] **Note Templates**: Predefined templates for common note types
- [ ] **Backup & Restore**: Manual backup to Google Drive/iCloud

## 🐞 Known Issues

- None reported at the moment
- Please report any issues in the [Issues](https://github.com/yourusername/note_app/issues) section

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### How to Contribute

1. **Fork the Repository**
   ```bash
   git clone https://github.com/yourusername/note_app.git
   cd note_app
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**
   - Write clean, documented code
   - Follow the existing code style
   - Add tests if applicable
   - Update documentation as needed

3. **Test Your Changes**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Submit a Pull Request**
   - Provide a clear description of your changes
   - Reference any related issues
   - Include screenshots for UI changes
   - Ensure all tests pass

### Contribution Guidelines

- **Code Style**: Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- **Commit Messages**: Use clear, descriptive commit messages
- **Documentation**: Update README and inline documentation
- **Testing**: Add unit tests for new features
- **Issues**: Check existing issues before creating new ones

### Areas for Contribution

- 🐛 Bug fixes
- ✨ New features
- 📝 Documentation improvements
- 🎨 UI/UX enhancements
- 🧪 Test coverage
- 🌍 Translations

## 👥 Authors

- **Your Name** - *Initial work* - [GitHub Profile](https://github.com/yourusername)

See also the list of [contributors](https://github.com/yourusername/note_app/contributors) who participated in this project.

## 🙏 Acknowledgments

- Thanks to the Flutter team for the amazing framework
- Firebase for the backend services
- The open-source community for the wonderful packages
- Design inspiration from [Dribbble](https://dribbble.com/shots/11875872-A-simple-and-lightweight-note-app)
- Icon by [Jocularityart](https://www.flaticon.com/fr/sticker-gratuite/note-collante_6558596)

## 📄 License

[MIT License](https://opensource.org/licenses/MIT). This project is released under the MIT license,
which means that you can use, copy, modify and distribute the source code freely.
