class WifiData {
  final int? id;
  final String ssid;
  final int dbm;
  final String location;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  WifiData({
    this.id, 
    required this.ssid,
    required this.dbm,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'ssid': ssid,
      'dbm': dbm,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory WifiData.fromMap(Map<String, dynamic> map) {
    return WifiData(
      id: map['id'],
      ssid: map['ssid'],
      dbm: map['dbm'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
