import 'package:bluetooth_detector/assigned_numbers/company_identifiers.dart';
import 'package:bluetooth_detector/report_view/device_map_view.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:bluetooth_detector/report_view/duration.dart';
import 'package:bluetooth_detector/report_view/device_view/device_detail_view/property_table_view.dart';
import 'package:bluetooth_detector/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report/device.dart';
import 'package:bluetooth_detector/settings.dart';

class DeviceDetailView extends StatelessWidget {
  late Device device;

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
