import 'dart:io';

import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';

// import 'package:bluetooth_detector/utils/snackbar.dart';
import 'package:bluetooth_detector/styles/colors.dart';
import 'package:bluetooth_detector/styles/button_styles.dart';

class BluetoothOffView extends StatelessWidget {
  BluetoothOffView({super.key, this.adapterState = AvailabilityState.unknown});

  AvailabilityState adapterState;

  Widget bluetoothOffIcon(BuildContext context) {
    return const Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
      color: colors.primaryText,
    );
  }

  Widget errorText(BuildContext context) {
    String? state = adapterState.toString().split(".").last;
    return Text(
      'Bluetooth Adapter is ${state ?? 'not available'}',
      selectionColor: colors.primaryText,
      style: const TextStyle(color: colors.primaryText),
    );
  }

  Widget turnOnBluetoothButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: AppButtonStyle.enableBluetoothButtonStyle,
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
        backgroundColor: colors.background,
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
