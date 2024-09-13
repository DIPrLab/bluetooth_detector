import 'package:bluetooth_detector/styles/styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report_view/device_view/device_view.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:bluetooth_detector/report/device.dart';
import 'package:bluetooth_detector/settings.dart';

class ReportView extends StatefulWidget {
  ReportView(Settings this.settings, {super.key, required this.report});

  final Report report;
  final Settings settings;
  late List<Device?> devices;

  @override
  ReportViewState createState() => ReportViewState();
}

class ReportViewState extends State<ReportView> {
  @override
  void initState() {
    super.initState();

    widget.devices = widget.report.devices();

    widget.devices
        .sorted(
            (a, b) => a!.locations().length.compareTo(b!.locations().length))
        .reversed;
  }

  void sortByTime() {
    setState(() {
      widget.devices.sorted((a, b) {
        int threshold = widget.settings.thresholdTime.toInt();
        Duration deviceAValue = a!.timeTravelled(threshold);
        Duration deviceBValue = b!.timeTravelled(threshold);
        return deviceAValue.compareTo(deviceBValue);
      }).reversed;
    });
  }

  void sortByIncidence() {
    setState(() {
      widget.devices.sorted((a, b) {
        int threshold = widget.settings.thresholdTime.toInt();
        int deviceAValue = a!.incidence(threshold);
        int deviceBValue = b!.incidence(threshold);
        return deviceAValue.compareTo(deviceBValue);
      }).reversed;
    });
  }

  void sortByLocation() {
    setState(() {
      widget.devices.sorted((a, b) {
        int deviceAValue = a!.locations().length;
        int deviceBValue = b!.locations().length;
        return deviceAValue.compareTo(deviceBValue);
      }).reversed;
    });
  }

  Widget sortButton() {
    return PopupMenuButton<Null>(
      icon: const Icon(
        Icons.sort,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: ListTile(
            title: Text('Sort By Incidence', style: TextStyles.normal),
          ),
          onTap: (() {
            sortByIncidence();
          }),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Sort By Location', style: TextStyles.normal),
          ),
          onTap: (() {
            setState(() {
              sortByLocation();
            });
          }),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Sort By Time', style: TextStyles.normal),
          ),
          onTap: (() {
            setState(() {
              sortByTime();
            });
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(4),
              child: Stack(children: [
                Row(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text("Report",
                          textAlign: TextAlign.center, style: TextStyles.title),
                    ),
                    const Spacer(),
                  ],
                ),
                BackButton(
                  onPressed: () => Navigator.pop(context),
                  style: AppButtonStyle.buttonWithoutBackground,
                ),
                Row(
                  children: [Spacer(), sortButton()],
                )
              ])),
          Column(
            children: [
              ...widget.devices.map((device) =>
                  DeviceView(device!, widget.settings, report: widget.report)),
            ],
          ),
        ],
      ),
    ));
  }
}
