import 'package:bluetooth_detector/report_view/device_view/device_detail_view/device_detail_view.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:bluetooth_detector/report_view/device_map_view.dart';
import 'package:bluetooth_detector/report_view/duration.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report/device.dart';
import 'package:bluetooth_detector/settings.dart';

class DeviceView extends StatelessWidget {
  final Settings settings;
  final Device device;
  final Report report;

  DeviceView(Device this.device, Settings this.settings,
      {super.key, required this.report});

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
              Tile(
                  "Duration",
                  device
                      .timeTravelled(settings.scanTime.toInt())
                      .printFriendly()),
            ])
          ]),
          Row(children: [
            Spacer(),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SafeArea(child: DeviceDetailView(device))));
              },
              icon: Icon(Icons.info_outline),
              label: Text("Details"),
            ),
            Spacer(),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SafeArea(
                                child: DeviceMapView(
                              this.settings,
                              device: device,
                              report: report,
                            ))));
              },
              icon: Icon(Icons.map),
              label: Text("Device Routes"),
            ),
            Spacer(),
          ]),
        ]));
  }
}
