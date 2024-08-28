part of 'report.dart';

extension Statistics on Report {
  num riskScore(Device device, Settings settings) {
    return [
      (device.timeTravelled(settings.thresholdTime.toInt()).inSeconds, this.incidence(settings)),
      (device.incidence(settings.thresholdTime.toInt()), this.incidence(settings)),
      (device.areas(settings.thresholdDistance).length, this.areas(settings)),
    ].map((metric) => max(0, zScore(metric.$1, metric.$2))).reduce((a, b) => a + b);
  }

  double zScore(num x, Iterable<num> collection) {
    Stats stats = Stats.fromData(collection);
    double result = stats.standardDeviation == 0 ? 0 : (x - stats.average) / stats.standardDeviation;
    print("(" +
        x.toString() +
        " - " +
        stats.average.toString() +
        ") / " +
        stats.standardDeviation.toString() +
        " = " +
        result.toString());
    return result;
  }

  List<int> areas(Settings settings) {
    return report.entries.map((device) => device.value?.areas(settings.thresholdDistance).length ?? 0).toList();
  }

  List<int> incidence(Settings settings) {
    return report.entries.map((device) => device.value?.incidence(settings.thresholdTime.toInt()) ?? 0).toList();
  }

  List<int> timeTravelled(Settings settings) {
    return report.entries
        .map((device) => device.value?.timeTravelled(settings.thresholdTime.toInt()) ?? Duration(seconds: 0))
        .map((duration) => duration.inSeconds)
        .toList();
  }
}
