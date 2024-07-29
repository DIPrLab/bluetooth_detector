part of 'package:bluetooth_detector/scanner_view/scanner_view.dart';

extension Scanner on ScannerViewState {
  void dispose() {
    scanResultsSubscription.cancel();
  }

  Future startScan() async {
    // android is slow when asking for all advertisements,
    // so instead we only ask for 1/8 of them
    await UniversalBle.startScan();
    isScanning = true;
  }

  Future stopScan() async {
    await UniversalBle.stopScan();
    isScanning = false;
  }

  void rescan() {
    setState(() {
      stopScan();
      startScan();
    });
  }

  void probe(BleDevice device) async {
    if (autoConnect) {
      await UniversalBle.connect(device.deviceId);
      await UniversalBle.discoverServices(device.deviceId);
    }
  }
}
