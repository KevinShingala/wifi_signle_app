import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/wifi_service.dart';
import '../models/wifi_data.dart';
import '../database/db_helper.dart';

class WifiProvider extends ChangeNotifier {
  List<WifiData> _wifiData = [];
  List<WifiData> get wifiData => _wifiData;

  Future<void> scanAndSaveWifi(String location) async {
    final results = await WifiService.scanWifi();
    final Position position = await _getCurrentLocation();

    for (var wifi in [results]) {
      final newEntry = WifiData(
        id: null,
        ssid: wifi['ssid'],
        dbm: wifi['dbm'],
        location: location,
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );

      _wifiData.add(newEntry);
      DBHelper.insertData(newEntry);
    }

    print("--- Wi-Fi Data Scanned: $_wifiData");
    notifyListeners();
  }

  Future<void> loadSavedData() async {
    _wifiData = await DBHelper.fetchData();
    notifyListeners();
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
}
