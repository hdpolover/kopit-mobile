# Kopit 📋

**Kopit** (pun on "Copy it" and Czech for "to stack") is a powerful, privacy-focused clipboard manager for Android built with Flutter. It helps you track your clipboard history, organize snippets, and access them instantly.

## 🚀 Features

*   **Clipboard History**: Automatically saves everything you copy (Text, Links, Colors).
*   **Privacy First**: All data is stored locally on your device using a secure database.
*   **Smart Actions**: Quick copy, share, or edit your clips.
*   **Search & Filter**: Find what you need in seconds.
*   **Modern UI**: Clean Material 3 design with Dark Mode support.

## 🛠 Tech Stack

*   **Framework**: Flutter
*   **Language**: Dart
*   **Database**: Drift (SQLite)
*   **State Management**: BLoC
*   **Dependency Injection**: GetIt & Injectable
*   **Native Integration**: Kotlin (for Clipboard & Input Method Services)

## 📦 Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/hdpolover/kopit-mobile.git
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the code generator:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
4.  Run the app:
    ```bash
    flutter run
    ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
