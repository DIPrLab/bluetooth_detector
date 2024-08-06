import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  late double scanTime;
  late double thresholdTime;
  late double scanDistance;
  late double thresholdDistance;

  static Settings shared = Settings();

  Settings() {
    SharedPreferences.getInstance().then((prefs) {
      scanTime = prefs.getDouble("scanTime") ?? 10;
      thresholdTime = prefs.getDouble("thresholdTime") ?? 10;
      scanDistance = prefs.getDouble("scanDistance") ?? 10;
      thresholdDistance = prefs.getDouble("thresholdDistance") ?? 10;
    });
  }
}
