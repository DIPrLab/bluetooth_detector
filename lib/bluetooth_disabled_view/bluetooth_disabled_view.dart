import 'dart:io';

import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';

// import 'package:bluetooth_detector/utils/snackbar.dart';

class BluetoothOffView extends StatelessWidget {
  BluetoothOffView({super.key, this.adapterState = AvailabilityState.unknown});

  AvailabilityState adapterState;

  Widget bluetoothOffIcon(BuildContext context) {
    return const Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
    );
  }

  Widget errorText(BuildContext context) {
    String? state = adapterState.toString().split(".").last;
    return Text(
      'Bluetooth Adapter is ${state ?? 'not available'}',
    );
  }

  Widget turnOnBluetoothButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        child: const Text('TURN ON'),
        onPressed: () async {
          try {
            await UniversalBle.enableBluetooth();
          } catch (e) {
            // Snackbar.show(ABC.a, prettyException("Error Turning On:", e), success: false);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      // key: Snackbar.snackBarKeyA,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              bluetoothOffIcon(context),
              errorText(context),
              if (Platform.isAndroid || Platform.isLinux || Platform.isWindows) turnOnBluetoothButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
