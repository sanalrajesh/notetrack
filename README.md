# 📝 NoteTrack – Smart Offline Notes App

**NoteTrack** is a lightweight, high-performance note-taking application built with **Flutter**, designed for seamless offline usage. It emphasizes **fast data access, automatic syncing, and a sleek, modern UI**, making note management simple and efficient.  

---

## 📸 App Preview


| <img src="https://github.com/user-attachments/assets/876a8d45-c712-4da3-abfc-3f22536fa4f5" width="150"> | 
<img src="https://github.com/user-attachments/assets/27e9977f-148c-4127-8e62-048b8b4e317b" width="150"> |
<img src="https://github.com/user-attachments/assets/d6a5ae9b-0ed1-41bd-8bb7-f16aa7514583" width="150"> | 
<img src="https://github.com/user-attachments/assets/8ca39dc7-f032-4906-bac1-9138e729abca" width="150"> |
<img src="https://github.com/user-attachments/assets/20dce2c3-965c-4b15-be89-3d7fa57934e5" width="150"> |
<img src="https://github.com/user-attachments/assets/31cf33f2-85a2-46c2-bca5-b36149d869b4" width="150"> |


---






## ⚡ Key Features

- **Offline-First Storage**: All notes are stored locally using a fast NoSQL database.  
- **Auto Save**: Notes are automatically saved on exit—no need to press save.  
- **Dark/Light Theme Support**: Toggle between themes for comfortable reading in any environment.  
- **Organized Layout**: Notes displayed in a responsive grid with clear subject, title, and timestamp.  
- **Delete & Edit**: Quick actions for editing or removing notes.  
- **Cross-Device Ready**: Responsive design ensures perfect rendering on any mobile screen size.  

---

## 🛠 Technology Stack & Dependencies

The app leverages modern Flutter packages for robust performance:

- **Hive & Hive Flutter** – Lightweight, high-speed local storage.  
- **Provider** – Reactive state management and dependency injection.  
- **Flutter ScreenUtil** – Makes the UI responsive on all devices.  
- **Intl** – Localized date & time formatting for notes.  
- **Google Fonts** – Clean and consistent typography across the app.  

---

## 🏗 Architecture Overview

The project is structured around a **Provider-based MVVM architecture**:

1. **Model** – Defines the structure of notes and handles Hive serialization.  
2. **View** – UI components following Material Design 3 principles.  
3. **ViewModel/Provider** – Manages CRUD operations, app state, and notifies the UI on changes to ensure efficient rendering.  

This separation ensures a **scalable, maintainable, and high-performance codebase**.

---

## 🚀 Getting Started

Follow these steps to run **NoteTrack** locally:

1. **Clone the Repository**:  
   ```bash
   git clone https://github.com/sanalrajesh/notetrack.git
1. **Install Dependencies:**:  
   ```bash
   flutter pub get
1. **Generate Hive Adapters**:  
   ```bash
   flutter pub run build_runner build
1. **CloneRun the App**:  
   ```bash
   flutter run

📦 **APK Download**  
You can manually install and test the app by downloading the ready-to-use APK from the [Releases](https://github.com/sanalrajesh/notetrack/releases) section.  

👉 [Download NoteTrack APK (v1.0.0)](https://github.com/sanalrajesh/notetrack/releases/download/v1.0.1/app-arm64-v8a-release.apk)


🌟 Future Enhancements

Cloud sync across devices.

Rich-text formatting for notes.

Search and filter functionality.

Notification reminders for important notes.
