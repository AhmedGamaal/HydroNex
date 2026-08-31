# 🌱 HydroNex

**An AI-Integrated IoT Framework for Smart Hydroponic Farm Management and Plant Disease Diagnosis**

Built for **VICTORIS 5.0** — IEEE Mansoura Student Branch × IEEE Computer Society (Undergraduate Track)

[![Live Demo](https://img.shields.io/badge/demo-live-brightgreen)](#) <!-- replace # with your deployed URL -->
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## 📌 Project Status

*(Updated regularly as Phase 2 progresses — last updated: Aug 31, 2026)*

| Component | Status |
|---|---|
| Repository structure & setup | ✅ Done |
| Backend API skeleton (.NET) | 🚧 In Progress |
| Flutter app skeleton | 📋 Planned |
| Digital Twin simulation | 📋 Planned |
| Disease detection model integration | 📋 Planned |
| Monitoring Agent / Explainer Agent | 📋 Planned |
| Mobile UI screens | 📋 Planned |
| Live deployment | 📋 Planned |

> This project is under active development for VICTORIS 5.0 Phase 2 (deadline: Sep 15, 2026). Features listed above will be implemented and checked off progressively.

---

## 📖 Overview

Hydroponic farming is water-efficient and high-yield, but hard to manage — it demands continuous monitoring of water quality, environmental conditions, and plant health, and growers often rely on manual inspection and fragmented tools to catch problems before it's too late.

**HydroNex** solves this by combining **real-time IoT monitoring**, **AI-based plant disease detection**, **closed-loop automated control**, and a **conversational AI assistant** into a single integrated platform — so growers can monitor, diagnose, and act on their farm's health from one mobile app.

> 🇪🇬 Built with Egypt's hydroponics market and water-scarcity context in mind — see [`docs/proposal.pdf`](docs/proposal.pdf) for full market research and feasibility analysis.

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 🔬 **Plant Disease Detection** | Identifies potential diseases from plant leaf images using a pretrained computer vision model |
| 📡 **Real-Time Monitoring** | Tracks pH, EC, water temperature, air temperature/humidity, and light intensity continuously |
| 🤖 **AI-Powered Guidance** | Provides intelligent, data-grounded recommendations with clear reasoning |
| 💬 **Conversational Assistant** | Answers growers' questions using live farm data, powered by an LLM API |
| ⚙️ **Automated Smart Control** | Closed-loop control of pumps, grow lights, fans, and nutrient dosing based on live sensor thresholds |
| 📱 **Mobile App** | Full monitoring and control from a Flutter-based mobile application |

---

## 🏗️ System Architecture

```
IoT Sensing Layer (Digital Twin — Phase 2)
        │  pH · EC · Temperature · Humidity · Water Level · Light
        ▼
Connectivity Layer — REST API / JSON
        ▼
Backend Layer — ASP.NET Core + SQL Server + SignalR
        ▼
   ┌────────────────────────────────────────────┐
   │              AI Services Layer               │
   │  Disease Detection (MobileNetV2)             │
   │  Monitoring Agent + Explainer/Chat Agent      │
   │  LLM API (Gemini / OpenAI)                    │
   └────────────────────────────────────────────┘
        ▼                              ▼
Automated Control                 Application Layer
(Pumps · Fans · Relays)           Flutter Mobile App

```

> **Note:** Phase 2 uses a physically-informed **Digital Twin** simulation in place of physical hardware, with real ESP32 + sensor integration planned as a future step. The rest of the pipeline (backend, AI services, mobile app) connects to it exactly as it would to real hardware, via the same interface.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter |
| Backend | ASP.NET Core, SQL Server, SignalR |
| AI — Disease Detection | Pretrained MobileNetV2 (Hugging Face, fine-tuned on PlantVillage) |
| AI — Reasoning & Chat | Monitoring Agent + Explainer Agent, via Gemini / OpenAI API |
| Environment Simulation | Physically-informed Digital Twin (Phase 2) → Real ESP32 + Sensors (Future Plan) |

---

## 🚀 Getting Started

### Prerequisites
- [.NET SDK](https://dotnet.microsoft.com/download) (8.0+)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Python 3.10+](https://www.python.org/downloads/) (for AI agents / digital twin service)
- SQL Server (or LocalDB for development)

### Backend
```bash
cd backend/HydroNex.Api
dotnet restore
dotnet run
```

### Mobile App
```bash
cd mobile/hydronex_app
flutter pub get
flutter run
```

### AI Agents / Digital Twin
```bash
cd ai-agents   # or digital-twin
pip install -r requirements.txt
python main.py
```

> Full environment variable setup (API keys, connection strings) is documented in each subfolder's own README.

---

## 📂 Repository Structure

```
hydronex/
├── backend/          # ASP.NET Core API
├── mobile/           # Flutter application
├── ai-agents/        # Monitoring Agent + Explainer Agent
├── digital-twin/     # Digital twin simulation service
├── docs/             # Proposal
├── .gitignore
├── README.md
└── LICENSE
```

---

## 🌍 Alignment with UN Sustainable Development Goals

| SDG | How HydroNex Contributes |
|---|---|
| **SDG 2 — Zero Hunger** | Reduces crop loss through early AI-based disease detection |
| **SDG 6 — Clean Water & Sanitation** | Hydroponics uses up to 90% less water than traditional farming |
| **SDG 9 — Industry, Innovation & Infrastructure** | Applies IoT and AI to modernize agricultural infrastructure in Egypt |

---

## 👥 Team

| Name | Role |
|---|---|
| Ahmed Gamal | Backend Developer (.NET) |
| Mohamed Zaabal | Backend Developer (.NET) |
| Mohamed El Sanet | Backend Developer (.NET) |
| Nour Zahra | Flutter Developer |
| Samaa Hetata | Flutter Developer |
| Romaisaa Fetouh | UI/UX Designer |
| Mohamed El-Baioumy | Cloud/DevOps + AI Support |
| Halim | AI/ML Developer |

---

## 📄 Documentation

- [Structured Proposal](docs/proposal.pdf)


---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

<p align="center">Built with 🌱 for VICTORIS 5.0</p>
