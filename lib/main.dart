import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/wifi_provider.dart';
import 'services/work_manager_service.dart';
import 'screens/measure_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WorkManagerService.initialize();
  WorkManagerService.startBackgroundTask();

  MapboxOptions.setAccessToken(
      "pk.eyJ1Ijoia2V2aW4xMDIwIiwiYSI6ImNtNmh2YTljcTAxemMya3M3bDJ5OTExYjcifQ.9dCC8xSNXFtWPa-xs6HQVw");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WifiProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MeasureScreen(),
      ),
    );
  }
}
