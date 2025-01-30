import 'package:wifi_scan/wifi_scan.dart';

class WifiService {
  static Future<Map<String, dynamic>> scanWifi() async {
    try {
      CanGetScannedResults canGetScannedResults =
          await WiFiScan.instance.canGetScannedResults();
      print("------- ${canGetScannedResults.name}");
      final results = await WiFiScan.instance.getScannedResults();
      print("--- wifi results $results");
      if (results.isNotEmpty) {
        final bestSignal = results.reduce((a, b) => a.level > b.level ? a : b);
        return {'ssid': bestSignal.ssid, 'dbm': bestSignal.level};
      }
      return {};
    } catch (e) {
      print("error $e");
      return {};
    }
  }
}
