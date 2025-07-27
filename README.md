# ComfyBase Event Management System 🎫
Live link :    https://comfybase-plp-7wum.vercel.app/
A modern event management platform for seamless attendee engagement and interactive experiences.

## Preview of the app
<img width="542" height="1187" alt="image" src="https://github.com/user-attachments/assets/7c5dd8c9-868f-4a35-a112-49146ebd28fc" />
<img width="542" height="1187" alt="Screenshot From 2025-07-26 23-38-14" src="https://github.com/user-attachments/assets/5e7dcc6b-998b-4eac-8885-7d0e9df17bbe" />
<img width="542" height="1187" alt="Screenshot From 2025-07-26 23-38-02" src="https://github.com/user-attachments/assets/0a69f8b3-e0bc-466c-a077-07083f684b76" />
<img width="542" height="1187" alt="Screenshot From 2025-07-26 23-38-23" src="https://github.com/user-attachments/assets/ab71e942-0b25-4381-9481-4472df2c2220" />
<img width="542" height="1187" alt="Screenshot From 2025-07-26 23-38-32" src="https://github.com/user-attachments/assets/9190e9dd-d6d3-4179-b8a0-dcdd7008eb41" />




## 🌟 Features
- **Real-time Event Interactions**
  - Interactive note-taking 

- **Cross-Platform Accessibility**

  - Responsive design for all devices (Android, iOS, Web, Desktop)
- **Enhanced Attendee Experience**
  - Interactive session tracking
  - Multimedia-enhanced note-taking


## 🚀 Installation

### Prerequisites
- [Flutter](https://docs.flutter.dev/get-started/install) (v3.0 or higher recommended)
- Dart SDK (comes with Flutter)

### Setup
```bash
# Clone the repository
git clone https://github.com/IsoDevMate/comfybase-plp.git

# Navigate to the project directory
cd comfybase/kenyanvalley

# Get dependencies
flutter pub get

# Run the app (choose your platform: android, ios, web, macos, windows, linux)
flutter run
```

## 🛠️ Tech Stack
- **Frontend & App:**
  - Flutter (Dart)
  - Material Design
  - Provider (state management)
  - GoRouter (navigation)
  - Dio (networking)
  - Cross-platform: Android, iOS, Web, Desktop (macOS, Windows, Linux)
- **Backend:**
  - (Connects to your own backend API, e.g., Node.js/Express, MongoDB, Firebase, etc.)

## 🏗️ Architecture
- Modular feature-based folder structure
- Provider for state management
- GoRouter for navigation
- Dio for API requests
- Responsive UI for all platforms

## 🔐 Environment Variables
If your app connects to a backend, configure your API endpoints in `lib/core/constants/api_constants.dart` or via environment variables as needed.

## 📝 API Documentation (Example)
- **Authentication**
  - `POST /api/auth/login`
  - `POST /api/auth/register`
  - `GET /api/auth/verify`
- **Event Management**
  - `GET /api/events`
  - `POST /api/events`
  - `PUT /api/events/:id`
  - `DELETE /api/events/:id`
- **User Interaction**
  - `POST /api/notes`
  - `GET /api/streams`
  - `POST /api/media/upload`

## 🧪 Testing
```bash
# Run Flutter tests
flutter test
```

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📜 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team
- Barack Oduor Ouma - Project Lead & Software Engineer
