import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'wifi_service.dart';
import '../database/db_helper.dart';
import '../models/wifi_data.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final wifiResults = await WifiService.scanWifi();
    final Position position = await _getCurrentLocation();

    for (var wifi in [wifiResults]) {
      final newEntry = WifiData(
        id: null,
        ssid: wifi['ssid'],
        dbm: wifi['dbm'],
        location: inputData?['location'] ?? 'Background',
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );

      await DBHelper.insertData(newEntry);
    }

    return Future.value(true);
  });
}

Future<Position> _getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error("Location services are disabled.");
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permission denied.");
    }
  }

  return await Geolocator.getCurrentPosition();
}

class WorkManagerService {
  static void initialize() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  }

  static void startBackgroundTask() {
    Workmanager().registerPeriodicTask(
      "wifi_scan_task",
      "scanWifiInBackground",
      frequency: Duration(minutes: 15),
      inputData: {"location": "Background Scan"},
    );
  }
}
