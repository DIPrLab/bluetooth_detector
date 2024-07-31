import 'dart:async';

import 'package:bluetooth_detector/map_view/map_functions.dart';
import 'package:bluetooth_detector/map_view/map_view.dart';
import 'package:bluetooth_detector/map_view/position.dart';
import 'package:bluetooth_detector/report/file.dart';
import 'package:bluetooth_detector/report_view/report_view.dart';
import 'package:bluetooth_detector/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bluetooth_detector/report/device.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:bluetooth_detector/report/datum.dart';
import 'package:bluetooth_detector/settings_view/settings_view.dart';
import 'package:bluetooth_detector/settings.dart';
import 'package:universal_ble/universal_ble.dart';
import 'package:vibration/vibration.dart';
import 'package:latlng/latlng.dart';

part 'package:bluetooth_detector/scanner_view/buttons.dart';
part 'package:bluetooth_detector/scanner_view/scanner.dart';

class ScannerView extends StatefulWidget {
  ScannerView({super.key, this.adapterState = AvailabilityState.unknown});
  AvailabilityState adapterState;

  @override
  ScannerViewState createState() => ScannerViewState();
}

class ScannerViewState extends State<ScannerView> {
  bool isScanning = false;
  LatLng? location;
  late StreamSubscription<Position> positionStream;
  Offset? dragStart;
  double scaleStart = 1.0;
  Report report = Report({});
  bool autoConnect = false;

  late StreamSubscription<List<ScanResult>> scanResultsSubscription;
  List<BleDevice> scanResults = [];
  List<BluetoothDevice> systemDevices = [];

  late StreamSubscription<DateTime> timeStreamSubscription;

  final Stream<DateTime> _timeStream = Stream.periodic(Settings.scanTime, (int x) {
    return DateTime.now();
  });

  void log() {
    List<Device> devices = scanResults
        .map((d) => Device(d.deviceId, d.name ?? "", d.name ?? "Unimplemented", d.manufacturerData?.toList() ?? []))
        .toList();
    for (Device d in devices) {
      if (report.report[d.id] == null) {
        report.report[d.id] = Device(d.id, d.name, d.platformName, d.manufacturer);
      }
      report.report[d.id]?.dataPoints.add(Datum(location?.latitude.degrees, location?.longitude.degrees));
    }
  }

  void enableLocationStream() {
    positionStream = Geolocator.getPositionStream(locationSettings: Controllers.getLocationSettings(30))
        .listen((Position? position) {
      setState(() {
        location = position?.toLatLng();
      });
      if (isScanning) {
        log();
        rescan();
      }
    });
  }

  void disableLocationStream() {
    positionStream.pause();
    positionStream.cancel();
  }

  @override
  void initState() {
    super.initState();

    read().then((savedReport) {
      report = savedReport;
    });

    enableLocationStream();

    UniversalBle.onScanResult = (bleDevice) {
      scanResults.add(bleDevice);
      probe(bleDevice);
      if (mounted) {
        setState(() {});
      }
    };

    timeStreamSubscription = _timeStream.listen((currentTime) {
      if (isScanning) {
        log();
        rescan();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
          child: Row(children: [
        Spacer(),
        Column(
          children: [
            Spacer(),
            Row(children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: autoConnectButton(),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: locationButton(),
              ),
            ]),
            Row(children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: settingsButton(),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: scanButton(),
              ),
            ]),
            Spacer(),
          ],
        ),
        Spacer(),
      ])),
    );
  }
}
