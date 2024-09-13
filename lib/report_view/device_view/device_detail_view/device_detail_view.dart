import 'package:bluetooth_detector/report_view/device_view/device_detail_view/property_table_view.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report/device.dart';

class DeviceDetailView extends StatelessWidget {
  final Device device;

  DeviceDetailView(this.device);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      PropertyTable(device),
      TextButton(
        onPressed: () {},
        child: Spacer(),
      ),
    ]));
  }
}
