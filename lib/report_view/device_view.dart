import 'package:bluetooth_detector/assigned_numbers/company_identifiers.dart';
import 'package:bluetooth_detector/report_view/device_map_view.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:bluetooth_detector/report_view/duration.dart';
import 'package:bluetooth_detector/styles/button_styles.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report/device.dart';
import 'package:bluetooth_detector/settings.dart';

class DeviceView extends StatelessWidget {
  Settings settings;
  String deviceID;
  Report report;
  late Device device = report.report[deviceID]!;
  late Iterable<String> manufacturers = device.manufacturer
      .map((e) => company_identifiers[e.toRadixString(16).toUpperCase().padLeft(4, "0")] ?? "Unknown");

  DeviceView(Settings this.settings, {super.key, required this.deviceID, required this.report});

  Widget DataRow(String label, String value) {
    if (value.isEmpty) {
      return SizedBox.shrink();
    }
    String text = label;
    if (label.isNotEmpty) {
      text += ": ";
    }
    text += value;

    return Text(text, textAlign: TextAlign.left);
  }

  Widget Tile(String label, Object value, [Color? color = null]) {
    return Container(
        color: color,
        child: Center(
            child: Column(children: [
          Text(label),
          Text(
            value.toString(),
            textAlign: TextAlign.center,
          )
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SafeArea(
                              child: DeviceMapView(
                            this.settings,
                            device: deviceID,
                            report: report,
                          ))));
            },
            style: AppButtonStyle.buttonWithBackground,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              DataRow("Risk Score", report.riskScore(device, settings).toString()),
              Table(columnWidths: const {
                0: FlexColumnWidth(1.0),
                1: FlexColumnWidth(1.0),
                2: FlexColumnWidth(1.0),
              }, children: [
                TableRow(children: [
                  Tile(
                    "Incidence",
                    device.incidence(settings.scanTime.toInt()),
                  ),
                  Tile(
                    "Areas",
                    device.areas(settings.thresholdDistance).length,
                  ),
                  Tile("Duration", device.timeTravelled(settings.scanTime.toInt()).printFriendly()),
                ])
              ]),
              PropertyTable(device),
            ])));
  }
}

class PropertyTable extends StatelessWidget {
  final Device device;

  const PropertyTable(this.device, {super.key});

  @override
  Widget build(context) {
    return DataTable(
      sortAscending: true,
      sortColumnIndex: 1,
      showBottomBorder: false,
      columns: const [
        DataColumn(
            label: Text(
          'Property',
        )),
        DataColumn(
            label: Text(
              'Value',
            ),
            numeric: true),
      ],
      rows: [
        DataRow(
          cells: [
            DataCell(Text(
              "UUID",
            )),
            DataCell(Text(device.id.toString(), textAlign: TextAlign.right)),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(
              "Name",
            )),
            DataCell(Text(device.name, textAlign: TextAlign.right)),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(
              "Platform",
            )),
            DataCell(Text(device.platformName, textAlign: TextAlign.right)),
          ],
        ),
        DataRow(
          cells: [
            DataCell(Text(
              "Manufacturer",
            )),
            DataCell(Text(
                device.manufacturer
                    .map((e) => company_identifiers[e.toRadixString(16).toUpperCase().padLeft(4, "0")] ?? "Unknown")
                    .join(", "),
                textAlign: TextAlign.right)),
          ],
        ),
      ],
    );
  }
}
