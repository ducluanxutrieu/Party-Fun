# Party-Fun

A full-stack party booking platform consisting of multiple components:

| Component | Tech | Description |
|---|---|---|
| `party_server` | Node.js + Express + MongoDB | REST API backend |
| `party_web/Client` | Angular 22 | Customer-facing web app |
| `party_web/Dashboard` | Angular 21 | Admin dashboard |
| `party_booking_flutter` | Flutter | Mobile app (Android & iOS) |
| `party_mobile` | Android (Gradle) | Native Android app |

## Architecture

```
party_server        → REST API on port 3000
party_web/Client    → Customer web on port 4200
party_web/Dashboard → Admin web on port 4200
party_booking_flutter → Mobile app (iOS/Android)
```

## Quick Start

### Backend
```bash
cd party_server
npm install
npm start
```

### Client Web
```bash
cd party_web/Client
pnpm install
pnpm start
```

### Admin Dashboard
```bash
cd party_web/Dashboard
pnpm install
pnpm start
```

### Flutter App
```bash
cd party_booking_flutter
flutter pub get
flutter run
```

## Requirements

- Node.js
- pnpm
- Angular CLI
- Flutter SDK
- MongoDB
