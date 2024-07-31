part of 'package:bluetooth_detector/scanner_view/scanner_view.dart';

extension Buttons on ScannerViewState {
  Widget autoConnectButton() {
    return FloatingActionButton.large(
      onPressed: () async {
        autoConnect = !autoConnect;
        print("Auto Connect: ${autoConnect}");
        setState(() {});
      },
      backgroundColor: colors.foreground,
      child: Icon(autoConnect ? Icons.bluetooth : Icons.bluetooth_disabled,
          color: colors.primaryText),
    );
  }

  Widget locationButton() {
    if (location == null) {
      return FloatingActionButton.large(
        onPressed: () async {
          enableLocationStream();
          location = await getLocation();
          print("Enabling Location Stream");
          setState(() {});
        },
        backgroundColor: colors.foreground,
        child: const Icon(Icons.location_disabled, color: colors.primaryText),
      );
    } else {
      return FloatingActionButton.large(
        onPressed: () {
          disableLocationStream();
          location = null;
          print("Disabling Location Stream");
          setState(() {});
        },
        backgroundColor: colors.foreground,
        child: const Icon(Icons.location_searching, color: colors.primaryText),
      );
    }
  }

  Widget scanButton() {
    if (isScanning) {
      return FloatingActionButton.large(
        onPressed: () {
          log();
          stopScan();
          setState(() {
            isScanning = false;
          });
          write(report);
          Vibration.vibrate(pattern: [
            250,
            100,
            100,
            100,
            100,
            100,
            250,
            100,
            500,
            250,
            250,
            100,
            750,
            500
          ], intensities: [
            255,
            0,
            255,
            0,
            255,
            0,
            255,
            0,
            255,
            0,
            255,
            0,
            255,
            0
          ]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SafeArea(child: ReportView(report: report))));
        },
        backgroundColor: colors.altText,
        child: const Icon(Icons.stop, color: colors.primaryText),
      );
    } else {
      return FloatingActionButton.large(
        onPressed: () {
          setState(() {
            isScanning = true;
          });
          startScan();
        },
        backgroundColor: colors.foreground,
        child: const Icon(Icons.play_arrow_rounded, color: colors.primaryText),
      );
    }
  }
}
