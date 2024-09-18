part of 'report.dart';

extension Cache on Report {
  void refreshCache(Settings settings) {
    Iterable<Device> devices = data.entries.map((device) => device.value!);

    timeTravelledStats = _timeTravelledStats(devices, settings);
    distanceTravelledStats = _distanceTravelledStats(devices, settings);
    incidenceStats = _incidenceStats(devices, settings);
    areaStats = _areaStats(devices, settings);
  }
}
