# 🤖 Aura – AI-Powered Study Partner
<img width="1280" height="720" alt="Image" src="https://github.com/user-attachments/assets/6019216f-cd2e-48cc-8538-8bd83230bd99" />



### 🚀 Aura is a **cross-platform Flutter application** designed to enhance your study experience with AI-powered document analysis and summarization.

---

## ✨ Key Features

Aura is designed to be your intelligent study companion, offering a suite of features that streamline and enhance your learning workflow:

### 📄 Document Upload & Management
- Effortlessly upload your study materials in PDF format.
- Organize, rename, and delete documents within the app.
- All documents are securely stored and easily accessible for future reference.

### 🧠 AI Summarization (Powered by Google Gemini AI)
- Instantly generate concise, intelligent summaries of your uploaded documents.
- Summaries are tailored to highlight key points, saving you time and improving comprehension.
- Supports summarization in both English and Arabic.

### 🗂️ Recent Uploads
- Quickly access your most recently uploaded documents from a dedicated section.
- Track your study progress and revisit important materials with ease.

### 📝 Summary Management
- Save AI-generated summaries for offline access.
- View, edit, and organize your summaries within the app.
- Share summaries with friends or classmates via social media, email, or messaging apps.

### 👤 User Profile & Account Management
- Update your personal information and profile picture.
- Change your password securely within the app.
- Option to delete your account and all associated data at any time.

### 🌐 Authentication & Security
- Secure sign-up and login with email/password.
- Email verification to ensure account authenticity.
- OAuth integration for quick login via Google, GitHub, or Discord.
- All authentication flows are designed with user privacy and security in mind.

### 🌙 Dark/Light Theme
- Seamlessly switch between dark and light modes for comfortable reading in any environment.
- Theme preference is saved and applied automatically on future launches.

### 🌏 Internationalization (i18n)
- Full support for both English and Arabic languages.
- Effortless language switching from within the app.
- All UI elements and AI summaries are localized for a native experience.

---

These features are built on a robust, scalable architecture, ensuring Aura remains fast, secure, and easy to use as your

---

## 🛠️ Tech Stack

- **Flutter**: Cross-platform UI framework
- **BLoC/Cubit**: State management
- **Clean Architecture**: Layered, maintainable codebase
- **Dio**: Networking
- **Hive**: Local storage and caching
- **Google Gemini AI**: Document summarization
- **Easy Localization**: Multi-language support
- **GoRouter**: Navigation
- **Device Preview**: Responsive design testing

---
## 🏗️ Architecture

The project follows **Clean Architecture** principles with a modular and scalable structure:
```
lib/
├── core/
│   ├── di/               # Dependency injection setup (e.g., service_locator.dart)
│   ├── helpers/          # General helpers (e.g., local storage, showSnackbar, database setup)
│   ├── networking/       # API clients, interceptors, network configuration
│   ├── routing/          # AppRouter, route names, navigation logic
│   ├── services/         # Global services (e.g., notifications, analytics, logging)
│   ├── themes/           # ThemeCubit, light/dark themes, text styles
│   ├── utils/            # Constants, date formatters, validators, general tools
│   └── widgets/          # Reusable widgets shared across the app
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/           # Models like UserModel, AuthResponseModel
│   │   │   └── repos/            # Repositories and implementations
│   │   └── presentation/
│   │       ├── manger/           # State management (Cubit/BLoC)
│   │       └── views/
│   │           ├── widgets/      # Feature-specific widgets
│   │           ├── otp_verification_view.dart
│   │           ├── sign_in_view.dart
│   │           └── sign_up_view.dart
│
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── manger/
│   │       └── views/
│   │           ├── home_view.dart
│   │           └── widgets/
│
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── manger/
│   │       └── views/
│   │           ├── profile_view.dart
│   │           └── widgets/
│
│   ├── summary/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── manger/
│   │       └── views/
│   │           ├── summary_view.dart
│   │           └── widgets/
│
│   ├── splash/
│   │   └── presentation/
│   │       └── views/
│   │           └── splash_view.dart
│
│   ├── onboarding/
│   │   └── presentation/
│   │       └── views/
│   │           └── onboarding_view.dart
│
│   └── ...               # Future features (e.g., settings, notifications, etc.)
│
├── aura.dart             # Root widget of the app (MaterialApp/Router)
└── main.dart             # Application entry point (bootstrapping, DI init, runApp)
```
# 🔍 Layer Descriptions

## ✅ `core/`
Holds global logic and services not tied to any specific feature.

- `di/` – Dependency Injection setup (e.g., using `get_it`)
- `helpers/` – Shared utilities (e.g., local storage, DB setup, showSnackbar)
- `networking/` – API clients, interceptors, and networking configurations
- `routing/` – Centralized navigation using `GoRouter` or custom routers
- `services/` – General services (e.g., notifications, analytics)
- `themes/` – App-wide theme configuration (light/dark modes, ThemeCubit)
- `utils/` – Constants, extensions, formatters, validators, etc.
- `widgets/` – Common reusable widgets shared across features

---

## ✅ `features/`
Each feature is isolated using **Clean Architecture**, with three main layers:

- `data/` – Handles remote/local data, DTOs, and repository implementations
- `domain/` – Business logic: Entities, Use Cases, abstract Repositories
- `presentation/` – UI layer with screens, widgets, and Cubits/BLoCs

---

## ✅ `main.dart`
The main entry point of the application.

- Initializes core services, routes, themes, and dependency injection.
- Launches the app using `runApp()`.

---

## ✅ `aura.dart`
The root widget of the app.

- Configures and returns `MaterialApp.router`
- Applies global themes, router configuration, and observers.

---

# 🚀 Benefits of This Structure

- 🔄 **Separation of concerns** – Clear boundaries between logic layers
- 🔬 **Easier testing** – Business logic is decoupled from UI
- 🧩 **Modularity** – Each feature is self-contained and scalable
- ♻️ **Reusability** – Shared logic is centralized in `core/`


---
## 📱 Screenshots

> ⏳ *Coming Soon*

---

## 🎥 Demo

> ⏳ *Coming Soon*

---

## 🚀 Getting Started

1. **Clone the repository:**
```bash
git clone https://github.com/your-username/aura.git
```
2. Install dependencies:
```bash
flutter pub get
```
3. Run the app:
```bash
flutter run
```

## 👥 Authors

- **Mahmoud Elnagar** - *Initial work* - [GitHub](https://github.com/Mahmoudelnagar5/)
- **Omar Ayman** - *Initial work* - [GitHub](https://github.com/Ammoor/)



