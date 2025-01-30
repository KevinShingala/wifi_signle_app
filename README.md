# Wi-Fi Signal Strength Data Collection App

## Overview
This Flutter application collects Wi-Fi signal strength data and visualizes it on a 3D map using `mapbox_maps_flutter`. The app consists of three main screens:

1. **3D Room Map** – Displays a basic 3D map of the space.
2. **Measurement Screen** – Captures and displays the Wi-Fi signal strength.
3. **Overlay Screen** – Displays the captured signal strength data on the map.

## Features
- Uses the `wifi_scan` plugin to access Wi-Fi information.
- Records Wi-Fi signal strength (dBm) at different locations.
- Implements a background service to continue data collection.
- Stores collected data in a local database.
- Visualizes the signal strength overlay on a 3D map.

## Installation
### Prerequisites
- Flutter SDK installed
- Android/iOS Emulator or Physical Device
- API keys for Mapbox (for `mapbox_maps_flutter` integration)

### Steps
1. Clone the repository:
   ```sh
   git clone git@github.com:KevinShingala/wifi_signle_app.git
   ```
2. Navigate to the project directory:
   ```sh
   cd wifi_signle_app
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## Dependencies
```yaml
  provider: ^6.1.2
  mapbox_maps_flutter: ^2.5.1
  wifi_scan: ^0.4.1+1
  workmanager: ^0.5.2
  sqflite: ^2.4.1
  latlong2: ^0.9.1
  geolocator: ^13.0.2
```

## App Flow
1. **Screen 1: Map View**
   - Displays a 3D map with room overlays.
2. **Screen 2: Measurement Screen**
   - Shows real-time signal strength.
   - "Capture" button stores signal strength data.
3. **Screen 3: Signal Strength Overlay**
   - Displays the map with overlaid signal strength values.

