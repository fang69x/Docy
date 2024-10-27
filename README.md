
---

# Docy

**Docy** is a Flutter-based document management application designed to store, scan, view, and access important documents. The app allows users to upload single files, multiple files, and even entire folders, offering seamless integration with Firebase Storage for storing documents and Firebase Firestore for managing user data.

## Features

- **User Authentication**: Secure login and signup with Firebase Authentication, including Google login.
- **Document Management**: Upload and manage various types of documents and folders.
- **Document Scanning**: Use the built-in scanner to scan physical documents and store them directly in the app.
- **Cloud Storage**: All documents are stored securely using Firebase Storage.
- **Cross-Platform**: Fully functional on both iOS and Android devices.

## Getting Started

These instructions will help you get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase Account](https://firebase.google.com/) (for authentication and storage)
- A text editor (e.g., [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio))

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/Docy.git
   cd docy
   ```

2. **Install dependencies:**

   Run the following command in your project root directory:

   ```bash
   flutter pub get
   ```

3. **Set up Firebase:**

   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Set up Firebase Authentication and enable Google login.
   - Set up Firebase Storage for storing documents.
   - Add your Firebase configuration to your Flutter app by following the [Firebase setup guide](https://firebase.flutter.dev/docs/overview).

4. **Run the app:**

   Connect a device or use an emulator, then run:

   ```bash
   flutter run
   ```

## Project Structure

The project follows the standard Flutter structure with some additional directories for managing state and Firebase services.

```plaintext
/lib
│
├── main.dart               # Entry point of the app
├── authentication/         # Firebase authentication logic
├── models/                 # Data models for documents and users
├── pages/                  # Screens (login, home, upload, etc.)
├── services/               # Firebase Firestore and Storage integration
└── widgets/                # Reusable widgets
```

## Future Improvements

- **Document Search**: Add functionality to search for documents by name or content.
- **Document Sharing**: Enable users to share documents directly from the app.
- **Offline Access**: Allow users to download documents for offline viewing.
- **Multi-Language Support**: Add support for multiple languages.

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

1. Fork the project.
2. Create your feature branch (`git checkout -b feature/new-feature`).
3. Commit your changes (`git commit -am 'Add a new feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
