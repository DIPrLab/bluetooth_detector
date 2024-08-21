import 'package:bluetooth_detector/styles/colors.dart';
import 'package:bluetooth_detector/styles/button_styles.dart';
import 'package:bluetooth_detector/styles/text_styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_detector/report_view/device_view.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:bluetooth_detector/settings.dart';

class ReportView extends StatefulWidget {
  ReportView(Settings this.settings, {super.key, required this.report});

  final Report report;
  final Settings settings;

  @override
  ReportViewState createState() => ReportViewState();
}

class ReportViewState extends State<ReportView> {
  @override
  void initState() {
    super.initState();
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
                    )
                  ])),
              Column(
                children: [
                  ...widget.report.report.keys
                      .sorted((a, b) => widget.report.report[a]!
                          .locations()
                          .length
                          .compareTo(widget.report.report[b]!.locations().length))
                      .reversed
                      .map((e) => DeviceView(widget.settings, deviceID: e, report: widget.report)),
                ],
              ),
            ],
          ),
        ));
  }
}
