# HydroNex Mobile

The **HydroNex Mobile Application** is the Flutter-based client application of the HydroNex smart hydroponics platform.

It provides users with an easy-to-use interface for monitoring hydroponic farms, viewing sensor readings, managing plants, receiving alerts, and interacting with the HydroNex backend services.

The mobile application communicates with the **HydroNex ASP.NET Core Web API** through RESTful APIs.

---

## 🌱 About HydroNex

HydroNex is a smart hydroponics management platform designed to help farmers and hydroponics users monitor and manage their plants efficiently.

The platform combines:

- 📱 Flutter Mobile Application
- ⚙️ ASP.NET Core Web API
- 🗄️ SQL Server Database
- 🤖 AI-based plant disease detection
- 🌡️ IoT/Sensor monitoring
- 🔔 Notifications and alerts

The mobile application acts as the main interface between the user and the HydroNex backend.

---

## 🚀 Features

### 🔐 Authentication

Users can:

- Register a new account
- Login securely
- Logout
- Maintain an authenticated session
- Access features according to their role

Authentication is handled through the HydroNex backend using JWT-based authentication.

---

### 🌱 Farm Management

Users can:

- Create and manage farms
- View their farms
- View farm details
- Manage plants associated with their farms
- Monitor the current status of their hydroponic environment

---

### 📊 Sensor Monitoring

The application displays sensor information received from the backend, such as:

- pH
- Electrical Conductivity (EC)
- Water Temperature
- Air Temperature
- Humidity
- Water Level
- CO₂
- Light Intensity

Sensor values can be presented through dashboards, cards, charts, and status indicators to make the data easier to understand.

---

### 🤖 Plant Disease Detection

HydroNex provides an AI-powered plant disease detection feature.

Users can:

1. Select or capture a plant image.
2. Upload the image.
3. Send it to the HydroNex backend.
4. Receive the AI prediction.
5. View the detected disease and related information.

---

### 🔔 Alerts & Notifications

The application can notify users when important conditions are detected, such as abnormal sensor readings or potential plant problems.

---

## 🏗️ Project Structure

The Flutter application follows a modular structure to keep the code maintainable and scalable.

```text
mobile/
│
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── network/
│   │   ├── theme/
│   │   └── utils/
│   │
│   ├── features/
│   │   ├── authentication/
│   │   ├── farms/
│   │   ├── plants/
│   │   ├── sensors/
│   │   ├── disease_detection/
│   │   └── notifications/
│   │
│   ├── models/
│   │
│   ├── services/
│   │
│   ├── widgets/
│   │
│   └── main.dart
│
├── assets/
│
├── test/
│
├── pubspec.yaml
└── README.md
```

The exact structure may evolve as new features are added.

---

## 🔌 Backend Integration

The mobile application communicates with the HydroNex backend through REST APIs.

### Backend

The backend is built using:

- ASP.NET Core
- C#
- Entity Framework Core
- SQL Server
- ASP.NET Core Identity
- JWT Authentication

The backend provides endpoints for authentication, farms, plants, sensors, images, disease detection, and other HydroNex services.

### API Base URL

For development, the API can be configured through the application's environment/configuration.

Example:

```text
https://hydronex-api.azurewebsites.net
```

> The production API URL should be stored in one centralized configuration location rather than being hardcoded throughout the application.

---

## 📡 API Communication

The Flutter application should use a dedicated API/network layer for communicating with the backend.

A typical request flow is:

```text
Flutter UI
    │
    ▼
Feature / Controller
    │
    ▼
Repository / Service
    │
    ▼
HTTP Client
    │
    ▼
HydroNex API
    │
    ▼
Database / AI Services
```

This separation keeps the UI independent from the backend implementation.

---

## 🔑 Authentication Flow

The authentication process follows this general flow:

```text
User
 │
 ▼
Flutter Login Screen
 │
 ▼
POST /api/auth/login
 │
 ▼
HydroNex API
 │
 ▼
JWT Token
 │
 ▼
Flutter Secure Storage
 │
 ▼
Authenticated API Requests
```

The JWT token should be attached to protected API requests using the `Authorization` header:

```http
Authorization: Bearer <token>
```

---

## 🛠️ Technologies

| Technology | Purpose |
|---|---|
| Flutter | Mobile application framework |
| Dart | Programming language |
| REST API | Backend communication |
| ASP.NET Core | Backend API |
| JWT | Authentication |
| SQL Server | Database |
| Entity Framework Core | Data access |
| Git & GitHub | Version control |

---

## 📦 Getting Started

### Prerequisites

Make sure you have installed:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android Emulator or physical Android device
- Git

Check your Flutter installation:

```bash
flutter doctor
```

---

### Clone the Repository

```bash
git clone https://github.com/AhmedGamaal/HydroNex.git
```

Navigate to the mobile project:

```bash
cd HydroNex/mobile
```

---

### Install Dependencies

Run:

```bash
flutter pub get
```

---

### Run the Application

Connect an emulator or physical device and run:

```bash
flutter run
```

---

## ⚙️ API Configuration

Before running the application, make sure the API base URL points to the correct backend environment.

For example:

```dart
const String baseUrl = "https://hydronex-api.azurewebsites.net";
```

For local development, the URL may be different depending on whether the application is running on an Android emulator, iOS simulator, or physical device.

> Avoid committing private keys, secrets, passwords, or sensitive configuration values to GitHub.

---

## 🧪 Testing

Run Flutter tests using:

```bash
flutter test
```

For static analysis:

```bash
flutter analyze
```

Before submitting changes, make sure:

```bash
flutter analyze
flutter test
```

complete successfully.

---

## 🔄 Development Workflow

Before starting work:

```bash
git pull origin main
```

Create a feature branch:

```bash
git checkout -b feature/feature-name
```

After completing the feature:

```bash
git add .
git commit -m "Add feature-name"
git push origin feature/feature-name
```

Create a Pull Request to merge the changes into `main`.

---

## 🤝 Team Responsibilities

The Mobile Team is responsible for:

- Flutter UI implementation
- Navigation
- State management
- API integration
- Authentication handling
- Sensor data visualization
- Image upload
- Disease detection interface
- Error handling
- Loading and empty states
- Mobile-side validation
- Testing and debugging

The mobile application should communicate with the backend through the documented API endpoints rather than directly accessing the database.

---

## 📚 API Documentation

The HydroNex backend provides Swagger/OpenAPI documentation for available endpoints.

The API documentation should be used by the Flutter team to understand:

- Endpoint URLs
- HTTP methods
- Request parameters
- Request bodies
- Response models
- Authentication requirements
- Error responses

---

## 🔗 Project Components

HydroNex consists of multiple components:

- **Mobile:** Flutter mobile application
- **Backend:** ASP.NET Core Web API
- **AI:** Plant disease detection services
- **Database:** SQL Server

The mobile application is responsible for the user-facing experience and communicates with the backend through the API layer.

---

## 👥 Contributors

HydroNex is developed as a graduation project by a multidisciplinary team working across:

- Backend Development
- Mobile Development
- Artificial Intelligence
- UI/UX Design
- Cloud / Deployment

---

## 📄 License

This project is developed for educational and graduation-project purposes.
