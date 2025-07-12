# भगवद्गीता (Bhagavad Gita) App

A beautiful and spiritual Flutter application that provides access to all 18 chapters and 700 verses of the Bhagavad Gita with detailed explanations.

## 🌟 Features

- **Complete Bhagavad Gita**: All 18 chapters with 700 verses
- **Beautiful Religious Theme**: Saffron and spiritual blue color scheme
- **Detailed Slok Information**: Sanskrit text, transliteration, word meanings, translation, and purport
- **Responsive Design**: Works on all screen sizes
- **Offline Support**: Cached data for better performance
- **Smooth Navigation**: Intuitive user interface

## 📱 Screenshots

The app includes the following screens:
- **Home Screen**: Welcome screen with app introduction
- **Chapters Screen**: Grid view of all 18 chapters
- **Sloks Screen**: List of all verses in a selected chapter
- **Slok Detail Screen**: Complete information about a specific verse

## 🛠️ Technical Stack

- **Framework**: Flutter
- **State Management**: GetX
- **HTTP Client**: Dio
- **UI Components**: Material Design with custom theme
- **Loading Effects**: Shimmer animations
- **Fonts**: Google Fonts (Poppins)

## 🎨 Design Theme

The app uses a spiritual and religious theme with:
- **Primary Color**: Saffron (#FF9933)
- **Secondary Color**: Spiritual Blue (#1A237E)
- **Background**: Light Cream (#FFF8E1)
- **Text Colors**: Dark Brown (#3E2723) and Light Brown (#8D6E63)

## 📁 Project Structure

```
lib/
├── controllers/          # GetX controllers
│   ├── chapters_controller.dart
│   ├── sloks_controller.dart
│   └── slok_detail_controller.dart
├── services/            # API services
│   └── api_service.dart
├── Screens/            # UI screens
│   ├── Chapters/
│   ├── Sloks/
│   ├── SlokDetail/
│   └── Home/
├── utils/              # Utilities
│   └── app_theme.dart
├── widgets/            # Reusable widgets
│   ├── loading_widget.dart
│   └── error_widget.dart
└── main.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.5.3 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd bhagvat_geeta
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📡 API Integration

The app uses the following APIs:
- **Chapters API**: `https://vedicscriptures.github.io/chapters`
- **Sloks API**: `https://vedicscriptures.github.io/slok/{chapter_number}`
- **Slok Detail API**: `https://vedicscriptures.github.io/slok/{chapter_number}/{slok_number}`

## 🎯 Features in Detail

### 1. Chapters Screen
- Displays all 18 chapters in a beautiful grid layout
- Each chapter card shows:
  - Chapter number
  - Sanskrit name
  - English translation
  - Number of verses
- Pull-to-refresh functionality
- Error handling with retry option

### 2. Sloks Screen
- Lists all verses of a selected chapter
- Each slok card displays:
  - Verse number
  - Sanskrit text
  - Transliteration (if available)
  - Word meanings (if available)
- Smooth scrolling and loading states

### 3. Slok Detail Screen
- Complete information about a specific verse:
  - Sanskrit text with proper formatting
  - Transliteration
  - Word-by-word meanings
  - Complete translation
  - Detailed purport/explanation
- Beautiful card-based layout
- Easy navigation back to chapter

### 4. Home Screen
- Welcome screen with app introduction
- Quick statistics (18 chapters, 700 verses)
- Direct navigation to chapters
- Beautiful gradient background

## 🔧 Customization

### Theme Customization
The app theme can be customized in `lib/utils/app_theme.dart`:
- Colors
- Gradients
- Text styles
- Card decorations

### API Configuration
API endpoints can be modified in `lib/services/api_service.dart`:
- Base URL
- Timeout settings
- Error handling

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  google_fonts: ^6.1.0
  font_awesome_flutter: ^10.7.0
  dio: ^5.4.0
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^2.7.0
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- Bhagavad Gita text and translations
- Flutter community for excellent documentation
- GetX for state management
- Dio for HTTP client functionality

## 📞 Support

For support and questions, please open an issue in the repository.

---

**ॐ नमः शिवाय** (Om Namah Shivaya)
