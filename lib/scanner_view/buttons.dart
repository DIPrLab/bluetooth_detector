part of 'package:bluetooth_detector/scanner_view/scanner_view.dart';

extension Buttons on ScannerViewState {
  Widget autoConnectButton() {
    return FloatingActionButton.large(
      onPressed: () async {
        autoConnect = !autoConnect;
        print("Auto Connect: ${autoConnect}");
        setState(() {});
      },
      child: Icon(
        autoConnect ? Icons.bluetooth : Icons.bluetooth_disabled,
      ),
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
        child: const Icon(
          Icons.location_disabled,
        ),
      );
    } else {
      return FloatingActionButton.large(
        onPressed: () {
          disableLocationStream();
          location = null;
          print("Disabling Location Stream");
          setState(() {});
        },
        child: const Icon(
          Icons.location_searching,
        ),
      );
    }
  }

  Widget scanButton() {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton.large(
        onPressed: () {
          log();
          stopScan();
          write(widget.report);
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
                  builder: (context) => SafeArea(
                      child:
                          ReportView(widget.settings, report: widget.report))));
        },
        child: const Icon(
          Icons.stop,
        ),
      );
    } else {
      return FloatingActionButton.large(
        onPressed: () {
          startScan();
        },
        child: const Icon(
          Icons.play_arrow_rounded,
        ),
      );
    }
  }

  Widget settingsButton() {
    return FloatingActionButton.large(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SafeArea(child: SettingsView(widget.settings))));
        setState(() {});
      },
      child: Icon(
        Icons.settings,
      ),
    );
  }
}
