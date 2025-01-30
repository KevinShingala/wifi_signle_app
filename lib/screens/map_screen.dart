import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wifi_signal_mapping/utils/utils.dart';
import '../providers/wifi_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapboxMap mapboxMap;
  PointAnnotationManager? pointAnnotationManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("3D Map with Wi-Fi Overlay")),
      body: MapWidget(
        styleUri: MapboxStyles.SATELLITE_STREETS,
        mapOptions: MapOptions(
            pixelRatio: 1,
            constrainMode: ConstrainMode.HEIGHT_ONLY,
            orientation: NorthOrientation.UPWARDS,
            glyphsRasterizationOptions: GlyphsRasterizationOptions(
                rasterizationMode:
                    GlyphsRasterizationMode.ALL_GLYPHS_RASTERIZED_LOCALLY)),
        onMapCreated: (map) async {
          mapboxMap = map;
          pointAnnotationManager =
              await map.annotations.createPointAnnotationManager();

          await mapboxMap.setCamera(CameraOptions(
            center: Point(
                coordinates: Position(
                    context.read<WifiProvider>().wifiData.first.longitude,
                    context.read<WifiProvider>().wifiData.first.latitude)),
            zoom: 30.0,
          ));
          _addWifiMarkers();
        },
      ),
    );
  }

  void _addWifiMarkers() async {
    final wifiProvider = Provider.of<WifiProvider>(context, listen: false);
    pointAnnotationManager?.deleteAll();
    Map<String, dynamic> imageData = await iconToUint8List(Icons.wifi);

    await mapboxMap.style.addStyleImage(
      "wifi-icon",
      1.0,
      MbxImage(
          data: imageData["image"],
          width: imageData["width"],
          height: imageData["height"]),
      false,
      [],
      [],
      null,
    );
    for (var wifi in wifiProvider.wifiData) {
      double latitude = wifi.latitude;
      double longitude = wifi.longitude;
      await pointAnnotationManager?.create(
        PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(longitude, latitude),
          ),
          iconSize: 0.5,
          iconImage: "wifi-icon",
          textColor: _getSignalColor(wifi.dbm),
          // iconAnchor: IconAnchor.BOTTOM_LEFT,
          iconColor: _getSignalColor(wifi.dbm),
          textField: "${wifi.ssid} (${wifi.dbm} dBm)",
          textSize: 12.0,
        ),
      );
    }
  }

  int _getSignalColor(int strength) {
    if (strength >= -50) {
      return int.tryParse("0xFF00FF00") ?? 0;
    } else if (strength >= -70) {
      return int.tryParse("0xFFFFA500") ?? 0;
    } else {
      return int.tryParse("0xFFFF0000") ?? 0;
    }
  }
}
