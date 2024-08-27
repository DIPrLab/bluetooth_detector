import 'package:bluetooth_detector/styles/colors.dart';
import 'package:bluetooth_detector/styles/button_styles.dart';
import 'package:bluetooth_detector/styles/text_styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report_view/device_view.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:bluetooth_detector/report/device.dart';
import 'package:bluetooth_detector/settings.dart';

class ReportView extends StatefulWidget {
  ReportView(Settings this.settings, {super.key, required this.report});

  final Report report;
  final Settings settings;
  late List<String> devices;

  @override
  ReportViewState createState() => ReportViewState();
}

class ReportViewState extends State<ReportView> {
  @override
  void initState() {
    super.initState();

    widget.devices = widget.report.report.keys.toList();

    widget.devices
        .sorted((a, b) =>
            widget.report.report[a]!.locations().length.compareTo(widget.report.report[b]!.locations().length))
        .reversed;
  }

  void sortByTime() {
    setState(() {
      widget.devices.sorted((a, b) {
        Device deviceA = widget.report.report[a]!;
        Device deviceB = widget.report.report[b]!;
        int threshold = widget.settings.thresholdTime.toInt();
        Duration deviceAValue = deviceA.timeTravelled(threshold);
        Duration deviceBValue = deviceB.timeTravelled(threshold);
        return deviceAValue.compareTo(deviceBValue);
      }).reversed;
    });
  }

  void sortByIncidence() {
    setState(() {
      widget.devices.sorted((a, b) {
        Device deviceA = widget.report.report[a]!;
        Device deviceB = widget.report.report[b]!;
        int threshold = widget.settings.thresholdTime.toInt();
        int deviceAValue = deviceA.incidence(threshold);
        int deviceBValue = deviceB.incidence(threshold);
        return deviceAValue.compareTo(deviceBValue);
      }).reversed;
    });
  }

  void sortByLocation() {
    setState(() {
      widget.devices.sorted((a, b) {
        Device deviceA = widget.report.report[a]!;
        Device deviceB = widget.report.report[b]!;
        int deviceAValue = deviceA.locations().length;
        int deviceBValue = deviceB.locations().length;
        return deviceAValue.compareTo(deviceBValue);
      }).reversed;
    });
  }

  Widget sortButton() {
    return PopupMenuButton<Null>(
      icon: const Icon(Icons.sort, color: colors.primaryText),
      color: colors.foreground,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: ListTile(
            title: Text('Sort By Incidence', style: TextStyles.normal),
            tileColor: colors.foreground,
          ),
          onTap: (() {
            sortByIncidence();
          }),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Sort By Location', style: TextStyles.normal),
            tileColor: colors.foreground,
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
            tileColor: colors.foreground,
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
        backgroundColor: colors.background,
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
                          child: Text("Report", textAlign: TextAlign.center, style: TextStyles.title),
                        ),
                        const Spacer(),
                      ],
                    ),
                    BackButton(
                      color: colors.primaryText,
                      onPressed: () => Navigator.pop(context),
                      style: AppButtonStyle.buttonWithoutBackground,
                    ),
                    Row(
                      children: [Spacer(), sortButton()],
                    )
                  ])),
              Column(
                children: [
                  ...widget.devices.map((e) => DeviceView(widget.settings, deviceID: e, report: widget.report)),
                ],
              ),
            ],
          ),
        ));
  }
}
