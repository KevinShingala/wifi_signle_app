import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_signal_mapping/screens/map_screen.dart';
import 'package:wifi_signal_mapping/screens/signal_map_screen.dart';
import '../providers/wifi_provider.dart';

class MeasureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wifiProvider = Provider.of<WifiProvider>(context);
    wifiProvider.loadSavedData();
    return Scaffold(
      appBar: AppBar(title: Text("Measure Wi-Fi Strength")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: wifiProvider.wifiData.length,
              itemBuilder: (context, index) {
                final wifi = wifiProvider.wifiData[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignalMapScreen(wifi)),
                    );
                  },
                  title: Text(wifi.ssid),
                  subtitle: Text("Signal: ${wifi.dbm} dBm"),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => wifiProvider.scanAndSaveWifi("Measure Screen"),
                child: Text("Capture Wi-Fi"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
                child: Text("View on Map"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
