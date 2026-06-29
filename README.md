# EQ Request App

Emergency Quota Letter Generator for Indian Railways  
Electric Loco Shed, Ghaziabad

---

## Setup Instructions

### 1. Clone / Download
```bash
git clone https://github.com/YOUR_USERNAME/eq_request.git
cd eq_request
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run on Device
```bash
flutter run
```

### 4. Build APK Locally
```bash
flutter build apk --release
# APK at: build/app/outputs/flutter-apk/app-release.apk
```

### 5. GitHub Actions APK Build
- Push code to GitHub
- Go to Actions tab
- Download APK from Artifacts

---

## Add PNR API (Later)

1. Go to https://rapidapi.com
2. Search "IRCTC PNR Status"
3. Subscribe (free tier)
4. Copy your API Key
5. Open `lib/services/pnr_service.dart`
6. Replace `YOUR_RAPIDAPI_KEY` with your key

---

## Features

- Generate EQ Request letters as PDF
- Auto-fill from PNR (when API configured)
- 90+ railway offices searchable dropdown
- 3 passenger categories (On Duty / Without Duty / Civilian)
- Save & view old records date-wise
- Share via WhatsApp, Gmail, etc.
