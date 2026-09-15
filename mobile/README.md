# HydroNex Mobile 🌱

The mobile application for **HydroNex**, a smart hydroponics management system built to help users monitor and manage their hydroponic farms through a simple and interactive mobile experience.

The application is built using **Flutter** and communicates with the HydroNex backend through RESTful APIs.

---

## 🚀 Overview

The HydroNex Mobile application allows users to:

- 🔐 Register and log in
- 🌱 Manage farms and plants
- 📊 Monitor hydroponic sensor readings
- 🤖 Use AI-powered plant disease detection
- 🖼️ Upload plant images
- 🔔 Receive important alerts and notifications
- 📈 View and understand plant and environmental data

---

## 🛠️ Technologies

- **Flutter**
- **Dart**
- **REST APIs**
- **JWT Authentication**
- **ASP.NET Core Web API**
- **JSON**
- **Git & GitHub**

---

## 📁 Project Structure

```text
mobile/
│
├── android/
├── ios/
├── lib/
├── test/
├── assets/
│
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

The main Flutter application code is located inside the `lib` directory.

---

## 🔌 Backend Integration

The mobile application communicates with the HydroNex ASP.NET Core backend through REST APIs.

```text
Flutter Application
        │
        ▼
   REST API Calls
        │
        ▼
HydroNex ASP.NET Core API
        │
        ▼
     Database
```

The mobile application does **not** communicate directly with the database. All data access is handled through the backend API.

---

## 🔐 Authentication

HydroNex uses JWT-based authentication.

The general authentication flow is:

```text
User
  │
  ▼
Login / Register
  │
  ▼
HydroNex API
  │
  ▼
JWT Token
  │
  ▼
Authenticated Requests
```

Authenticated requests should include:

```http
Authorization: Bearer <token>
```

---

## 🌱 Main Modules

### Authentication

Handles:

- User registration
- User login
- Logout
- Authentication state
- JWT token management

### Farms

Allows users to:

- Create farms
- View farms
- View farm details
- Manage their hydroponic farms

### Plants

Allows users to:

- Add plants
- View plant information
- Associate plants with farms
- Monitor plant status

### Sensors

Displays environmental information collected from the hydroponic system, including:

- pH
- EC
- Water Temperature
- Air Temperature
- Humidity
- Water Level
- CO₂
- Light Intensity

### AI Disease Detection

Users can upload a plant image and receive an AI-based prediction from the HydroNex backend.

```text
Plant Image
    │
    ▼
Flutter Application
    │
    ▼
HydroNex API
    │
    ▼
AI Model
    │
    ▼
Prediction
    │
    ▼
Flutter Application
```

---

## ⚙️ Getting Started

### Requirements

Make sure you have:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android Emulator or a physical Android device
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

Navigate to the mobile directory:

```bash
cd HydroNex/mobile
```

---

### Install Dependencies

```bash
flutter pub get
```

---

### Run the Application

Connect an Android/iOS device or start an emulator, then run:

```bash
flutter run
```

---

## 🌐 API Configuration

The mobile application requires the HydroNex backend API to be available.

The API base URL should be configured in the appropriate application configuration/service rather than being duplicated throughout the project.

For the deployed environment, use the current HydroNex API URL provided by the backend team.

---

## 🧪 Testing

Run Flutter tests:

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

Before pushing changes, make sure the project builds successfully and:

```bash
flutter analyze
flutter test
```

complete without errors.

---

## 🔄 Development Workflow

Before starting new work:

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

Then create a Pull Request to merge the changes into `main`.

---

## 🤝 Mobile Team Responsibilities

The Mobile Team is responsible for:

- Flutter UI
- Navigation
- API integration
- Authentication
- State management
- Sensor data visualization
- Farm and plant management
- Image upload
- AI prediction interface
- Error handling
- Loading states
- Input validation
- Mobile testing

All communication with backend services should be performed through the provided API endpoints.

---

## 📚 API Documentation

The backend provides Swagger/OpenAPI documentation that should be used when integrating the mobile application with the API.

The documentation contains:

- Available endpoints
- HTTP methods
- Request parameters
- Request bodies
- Response models
- Authentication requirements
- Possible error responses

---

## 👥 HydroNex

HydroNex is developed as a multidisciplinary graduation project involving:

- Backend Development
- Mobile Development
- Artificial Intelligence
- UI/UX Design
- Cloud & Deployment

The Flutter application represents the mobile interface of the HydroNex ecosystem.

---

## 📄 License

This project is developed for educational and graduation-project purposes.
