import 'package:latlng/latlng.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  late double scanTime;
  late double thresholdTime;
  late double scanDistance;
  late double thresholdDistance;
  late List<LatLng> safeZones;

  static Settings shared = Settings();

  Settings() {
    SharedPreferences.getInstance().then((prefs) {
      scanTime = prefs.getDouble("scanTime") ?? 10;
      thresholdTime = prefs.getDouble("thresholdTime") ?? 10;
      scanDistance = prefs.getDouble("scanDistance") ?? 10;
      thresholdDistance = prefs.getDouble("thresholdDistance") ?? 10;
      safeZones = prefs.getStringList("safeZones")?.map((x) => LatLng.degree(0, 0)).toList() ?? [];
    });
  }
}
