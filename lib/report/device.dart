import 'package:collection/collection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:bluetooth_detector/report/datum.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:bluetooth_detector/assigned_numbers/company_identifiers.dart';
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

  Iterable<String> manufacturers() => manufacturer.map((e) =>
      company_identifiers[e.toRadixString(16).toUpperCase().padLeft(4, "0")] ??
      "Unknown");

  Set<LatLng> locations() {
    Set<LatLng> locations = {};
    this.dataPoints.forEach((dataPoint) {
      LatLng? location = dataPoint.location();
      if (location != null) {
        locations.add(location);
      }
    });
    return locations;
  }

  int incidence(int thresholdTime) {
    int result = 0;
    List<Datum> dataPoints =
        this.dataPoints.sorted((a, b) => a.time.compareTo(b.time));
    while (dataPoints.length > 1) {
      DateTime a = dataPoints.elementAt(0).time;
      DateTime b = dataPoints.elementAt(1).time;
      Duration c = b.difference(a);
      result += c > (Duration(seconds: thresholdTime) * 2) ? 1 : 0;
      dataPoints.removeAt(0);
    }
    return result;
  }

  Set<Area> areas(double thresholdDistance) {
    Set<Area> result = {};
    for (LatLng curr in locations()) {
      if (result.isEmpty) {
        result.add({curr});
        continue;
      }
      for (Area area in result) {
        for (LatLng location in area) {
          double distance = Geolocator.distanceBetween(
              curr.latitude.degrees,
              curr.longitude.degrees,
              location.latitude.degrees,
              location.longitude.degrees);
          if (distance <= thresholdDistance) {
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

  Duration timeTravelled(int thresholdTime) {
    Duration result = Duration();
    List<Datum> dataPoints =
        this.dataPoints.sorted((a, b) => a.time.compareTo(b.time));

    for (int i = 0; i < dataPoints.length - 1; i++) {
      DateTime time1 = dataPoints[i].time;
      DateTime time2 = dataPoints[i + 1].time;
      Duration time = time2.difference(time1);
      if (time < Duration(seconds: thresholdTime)) {
        result += time;
      }
    }

    return result;
  }

  List<Path> paths(int thresholdTime) {
    List<Path> paths = <Path>[];
    List<PathComponent> dataPoints = this
        .dataPoints
        .where((dataPoint) => dataPoint.location() != null)
        .map((datum) {
      LatLng location = LatLng.degree(datum.location()!.latitude.degrees,
          datum.location()!.longitude.degrees);
      return PathComponent(datum.time, location);
    }).sorted((a, b) => a.time.compareTo(b.time));

    while (!dataPoints.isEmpty) {
      PathComponent curr = dataPoints.first;
      dataPoints.removeAt(0);
      if (paths.isEmpty) {
        paths.add([curr]);
      } else {
        DateTime time1 = paths.last.last.time;
        DateTime time2 = curr.time;
        Duration time = time2.difference(time1);
        if (time < Duration(seconds: thresholdTime)) {
          paths.last.add(curr);
        } else {
          paths.add([curr]);
        }
      }
    }

    return paths;
  }

  double distanceTravelled(int thresholdTime) {
    double result = 0.0;
    paths(thresholdTime).map((path) {
      double result = 0.0;
      for (int i = 0; i < path.length - 1; i++) {
        PathComponent pc1 = path[i];
        PathComponent pc2 = path[i + 1];
        double distance = Geolocator.distanceBetween(
            pc1.location.latitude.degrees,
            pc1.location.longitude.degrees,
            pc2.location.latitude.degrees,
            pc2.location.longitude.degrees);
        result += distance;
      }
      return result;
    }).reduce((a, b) => a + b);
    return result;
  }
}
