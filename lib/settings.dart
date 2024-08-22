import 'package:latlng/latlng.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  late double scanTime;
  late double thresholdTime;
  late double scanDistance;
  late double thresholdDistance;
  late List<LatLng> safeZones;

  loadData() async {
    SharedPreferences.getInstance().then((prefs) {
      scanTime = prefs.getDouble("scanTime") ?? 10;
      thresholdTime = prefs.getDouble("thresholdTime") ?? 10;
      scanDistance = prefs.getDouble("scanDistance") ?? 10;
      thresholdDistance = prefs.getDouble("thresholdDistance") ?? 10;
      safeZones = prefs.getStringList("safeZones")?.map((x) {
            List<String> latlng = x.split(',');
            return LatLng.degree(double.tryParse(latlng[0]) ?? 0.0, double.tryParse(latlng[1]) ?? 0.0);
          }).toList() ??
          [];
    });
  }
}
