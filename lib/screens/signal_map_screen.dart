import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wifi_signal_mapping/models/wifi_data.dart';
import 'package:wifi_signal_mapping/utils/utils.dart';
import '../providers/wifi_provider.dart';

class SignalMapScreen extends StatefulWidget {
  WifiData wifiData;
  SignalMapScreen(this.wifiData);
  @override
  _SignalMapScreenState createState() => _SignalMapScreenState();
}

class _SignalMapScreenState extends State<SignalMapScreen> {
  late MapboxMap mapController;
  PointAnnotationManager? pointAnnotationManager;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addWifiMarkers() async {
    if (pointAnnotationManager != null) {
      pointAnnotationManager!.deleteAll();
      Map<String, dynamic> imageData = await iconToUint8List(Icons.wifi);

      await mapController.style.addStyleImage(
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
      pointAnnotationManager!.create(PointAnnotationOptions(
        geometry: Point(
            coordinates:
                Position(widget.wifiData.longitude, widget.wifiData.latitude)),
        iconSize: 1.5,
        iconImage: "wifi-icon",
        iconAnchor: IconAnchor.BOTTOM_LEFT,
        textField: "${widget.wifiData.ssid} (${widget.wifiData.dbm} dBm)",
        textSize: 20.0,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signal Strength Map')),
      body: MapWidget(
        onMapCreated: (controller) async {
          mapController = controller;
          pointAnnotationManager =
              await mapController.annotations.createPointAnnotationManager();
          mapController.setCamera(CameraOptions(
            center: Point(
                coordinates: Position(
                    widget.wifiData.longitude, widget.wifiData.latitude)),
            zoom: 15.0,
          ));
          _addWifiMarkers();
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Provider.of<WifiProvider>(context, listen: false).loadSavedData();
      //     _addWifiMarkers();
      //   },
      //   child: Icon(Icons.refresh),
      // ),
    );
  }
}
