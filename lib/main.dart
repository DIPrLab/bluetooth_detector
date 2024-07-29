import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';
import 'package:bluetooth_detector/bluetooth_disabled_view/bluetooth_disabled_view.dart';
import 'package:bluetooth_detector/scanner_view/scanner_view.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AvailabilityState _adapterState = AvailabilityState.unknown;

  @override
  void initState() {
    super.initState();
    UniversalBle.onAvailabilityChange = (state) {
      setState(() {
        _adapterState = state;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == AvailabilityState.poweredOn
        ? ScannerView(adapterState: _adapterState)
        : BluetoothOffView(adapterState: _adapterState);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: screen),
      theme: ThemeData(),
    );
  }
}
