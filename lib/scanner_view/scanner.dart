part of 'package:bluetooth_detector/scanner_view/scanner_view.dart';

extension Scanner on ScannerViewState {
  void dispose() {
    scanResultsSubscription.cancel();
  }

  Future startScan() async {
    // android is slow when asking for all advertisements,
    // so instead we only ask for 1/8 of them
    await UniversalBle.startScan();
  }

  Future stopScan() async {
    await UniversalBle.stopScan();
  }

  void rescan() {
    setState(() {
      stopScan();
      startScan();
    });
  }

  void probe(BluetoothDevice device) async {
    if (autoConnect) {
      await UniversalBle.connect(device.remoteId.toString());
      await UniversalBle.discoverServices(device.remoteId.toString());
    }
  }
}
