# CryptoChat

CryptoChat is a sophisticated Flutter-based messaging platform designed for maximum privacy and flexibility. It distinguishes itself by offering two distinct modes of operation: high-availability Online Messaging and a privacy-first Offline Messaging system built on a custom-engineered communication stack.

---

## 🚀 Key Features

* **Dual-Mode Communication**: 
    * **Online Mode**: Scalable real-time messaging powered by Firebase Firestore and secure Authentication.
    * **Offline Mode**: Direct peer-to-peer messaging and audio calls over local networks using a custom-built TCP/IP protocol stack.
* **Custom Encryption Engine**: All messages are processed through a specialized 'Cipher' engine that uses seed-based shifting to ensure data remains unreadable to unauthorized parties.
* **Advanced Audio Calls**: Integrated voice communication utilizing a custom-made signaling protocol for session management.
* **Reactive State Management**: Implementation of the BLoC/Cubit pattern for robust state handling across authentication and chat features.
* **Cross-Platform Design**: A single codebase providing a consistent experience with dynamic light and dark theming.

---

## 🛠 Custom Communication Protocol (Deep Dive)

A core pillar of CryptoChat is its independence from third-party servers for local communication. A proprietary protocol stack is created from the ground up:

### 1. Peer-to-Peer TCP/IP Stack
Unlike standard apps that rely on centralized APIs, CryptoChat implements a custom socket-based protocol. This allows devices on the same network to discover each other and establish secure, direct links without an internet connection.

### 2. Custom Signalization Protocol (Audio Calls)
To facilitate audio communication, i developed a bespoke signaling protocol. This handles:
* **Peer Discovery**: Identifying active users on the local subnet.
* **Handshaking**: Negotiating call parameters and encryption seeds between devices.
* **Session Management**: Coordinating the start, maintenance, and termination of real-time audio streams.

### 3. The Encryption Layer
Before any data is transmitted via the custom protocol, it is processed by our internal Cipher engine:
* **Custom ASCII Mapping**: A proprietary 94-character mapping system rather than standard UTF-8 for internal obfuscation.
* **Deterministic Seeding**: Encryption shifts are generated via a shared `Seed` (Random seed), ensuring that only the intended recipient with the matching seed can decode the transmission.



---

## 💻 Technical Architecture

* **Authentication**: Decoupled provider system currently supporting Firebase with built-in exceptions for invalid credentials, malformed emails, and registration failures.
* **State Logic**: 
    * `AuthBloc`: Manages the user lifecycle (Login, Logout, Initialize).
    * `ChatCubit`: Handles message streams, FAB visibility, and encryption seed injection.
    * `ThemeCubit`: Controls global application styling.
* **Service Layer**: `ChatService` acts as an abstraction layer between the UI and the underlying database or socket implementation.

---

## 🚦 Getting Started

### Prerequisites
* Flutter SDK (Stable)
* Firebase configuration (for Online Mode)
* Devices on a shared local network (for Offline Mode/Audio Calls)

### Installation
1. Clone the repository.
2. Run `flutter pub get` to fetch dependencies.
3. For Online Mode: Ensure `firebase_options.dart` is present in the root directory.
4. Build and run: `flutter run`.

---

## Security Disclaimer
The custom protocols and cipher implemented in CryptoChat are designed for educational purposes and private local communication. While they provide significant obfuscation, users should perform their own security audits before using the app for sensitive production data.