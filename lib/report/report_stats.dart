part of 'report.dart';

extension Statistics on Report {
  num riskScore(Device device, Settings settings) {
    Iterable<num> data = [
      (device.timeTravelled(settings.thresholdTime.toInt()).inSeconds, timeTravelledStats),
      (device.incidence(settings.thresholdTime.toInt()), incidenceStats),
      (device.areas(settings.thresholdDistance).length, areaStats),
      (device.distanceTravelled(settings.thresholdTime.toInt()), distanceTravelledStats),
    ].map((metric) => max(0, zScore(metric.$1, metric.$2)));
    num avgResult = Stats.fromData(data).average;
    // num addResult = data.reduce((a, b) => a + b);
    return avgResult;
  }

  static double zScore(num x, Stats stats) =>
      stats.standardDeviation == 0 ? 0 : (x - stats.average) / stats.standardDeviation;

  Stats _areaStats(Iterable<Device> devices, Settings settings) =>
      Stats.fromData(devices.map((device) => device.areas(settings.thresholdDistance).length ?? 0));

  Stats _incidenceStats(Iterable<Device> devices, Settings settings) =>
      Stats.fromData(devices.map((device) => device.incidence(settings.thresholdTime.toInt()) ?? 0));

  Stats _timeTravelledStats(Iterable<Device> devices, Settings settings) => Stats.fromData(devices
      .map((device) => device.timeTravelled(settings.thresholdTime.toInt()) ?? Duration(seconds: 0))
      .map((duration) => duration.inSeconds));

  Stats _distanceTravelledStats(Iterable<Device> devices, Settings settings) =>
      Stats.fromData(devices.map((device) => device.distanceTravelled(settings.thresholdTime.toInt()) ?? 0));
}
