import 'package:bluetooth_detector/report_view/device_view/device_detail_view/property_table_view.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report/device.dart';
import 'package:bluetooth_detector/styles/styles.dart';

class DeviceDetailView extends StatelessWidget {
  final Device device;

  DeviceDetailView(this.device);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Column(children: [
              Row(children: [
                BackButton(
                  onPressed: () => Navigator.pop(context),
                  style: AppButtonStyle.buttonWithBackground,
                ),
                Spacer(),
              ]),
              PropertyTable(device),
              TextButton(
                onPressed: () {},
                child: Spacer(),
              ),
            ])));
  }
}
