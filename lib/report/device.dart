import 'package:collection/collection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:bluetooth_detector/settings.dart';
import 'package:bluetooth_detector/report/datum.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

/// Device data type
///
/// This type is used to pair details of Bluetooth Devices
/// along with metadata that goes along with it
@JsonSerializable()
class Device {
  String id;
  String name;
  String platformName;
  List<int> manufacturer;
  Set<Datum> dataPoints = {};
  Device(this.id, this.name, this.platformName, this.manufacturer);
  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceToJson(this);

  Set<LatLng> locations() {
    Set<LatLng> locations = {};
    for (Datum dataPoint in this.dataPoints) {
      LatLng? location = dataPoint.location();
      if (location != null) {
        locations.add(location);
      }
    }
    return locations;
  }

  int incidence() {
    int result = 0;
    List<Datum> dataPoints = this.dataPoints.sorted((a, b) => a.time.compareTo(b.time));
    while (dataPoints.length > 1) {
      DateTime a = dataPoints.elementAt(0).time;
      DateTime b = dataPoints.elementAt(1).time;
      Duration c = b.difference(a);
      result += c > (Duration(seconds: Settings.shared.scanTime.toInt()) * 2) ? 1 : 0;
      dataPoints.removeAt(0);
    }
    return result;
  }

  Set<Area> areas() {
    Set<Area> result = {};
    for (LatLng curr in locations()) {
      if (result.isEmpty) {
        Area a = {};
        a.add(curr);
        result.add(a);
        continue;
      }
      for (Area area in result) {
        for (LatLng location in area) {
          double distance = Geolocator.distanceBetween(
              curr.latitude.degrees, curr.longitude.degrees, location.latitude.degrees, location.longitude.degrees);
          if (distance <= Settings.shared.thresholdDistance) {
            area.add(curr);
            break;
          }
        }
      }
    }
    for (Area area1 in result) {
      for (Area area2 in result.difference({area1})) {
        if (area1.intersection(area2).isNotEmpty) {
          area1 = area1.union(area2);
          result.remove(area2);
        }
      }
    }
    return result;
  }

  Duration timeTravelled() {
    Duration result = Duration();
    List<Datum> dataPoints = this.dataPoints.sorted((a, b) => a.time.compareTo(b.time));

    for (int i = 0; i < dataPoints.length - 1; i++) {
      DateTime time1 = dataPoints[i].time;
      DateTime time2 = dataPoints[i + 1].time;
      Duration time = time2.difference(time1);
      if (time < Duration(seconds: Settings.shared.scanTime.toInt())) {
        result += time;
      }
    }

    return result;
  }
}
