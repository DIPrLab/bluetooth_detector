import 'dart:math';

import 'package:bluetooth_detector/map_view/map_functions.dart';
import 'package:bluetooth_detector/styles/styles.dart';
import 'package:bluetooth_detector/settings_view/LatLngTile.dart';
import 'package:bluetooth_detector/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "slider.dart";
part "section_header.dart";

class LocationHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddLocation;

  LocationHeader({required this.onAddLocation});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: onAddLocation,
        ),
        title: Text("Add New Safe Zone"),
      ),
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SettingsView extends StatefulWidget {
  SettingsView(Settings this.settings, {super.key});

  final Settings settings;

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  void _addLocation() {
    getLocation().then((location) {
      setState(() {
        widget.settings.safeZones.add(location);
        save();
      });
    });
  }

  void save() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setDouble("scanTime", widget.settings.scanTime);
      prefs.setDouble("thresholdTime", widget.settings.thresholdTime);
      prefs.setDouble("scanDistance", widget.settings.scanTime);
      prefs.setDouble("thresholdDistance", widget.settings.thresholdTime);
      prefs.setStringList(
          "safeZones",
          widget.settings.safeZones
              .map((z) =>
                  z.latitude.degrees.toString() +
                  "," +
                  z.longitude.degrees.toString())
              .toList());
    });
    widget.settings.loadData();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BackButton(
              onPressed: () => Navigator.pop(context),
              style: AppButtonStyle.buttonWithoutBackground,
            ),
            header("Time"),
            settingsSlider(
                "Scanning Time",
                "${widget.settings.scanTime.toInt().toString()} seconds",
                0.0,
                100.0,
                widget.settings.scanTime,
                ((newValue) => clampThresholdTime(newValue))),
            settingsSlider(
                "Scanning Time Threshold",
                "${widget.settings.thresholdTime.toInt().toString()} seconds",
                0.0,
                100.0,
                widget.settings.thresholdTime,
                ((newValue) => clampScanTime(newValue))),
            header("Distance"),
            settingsSlider(
                "Scanning Distance",
                "${widget.settings.scanDistance.toInt().toString()} meters",
                0.0,
                100.0,
                widget.settings.scanDistance,
                ((newValue) => clampThresholdDistance(newValue))),
            settingsSlider(
                "Scanning Distance Threshold",
                "${widget.settings.thresholdDistance.toInt().toString()} meters",
                0.0,
                100.0,
                widget.settings.thresholdDistance,
                ((newValue) => clampScanDistance(newValue))),
            header("Safe Zones"),
            LocationHeader(onAddLocation: _addLocation),
            ...widget.settings.safeZones
                .map((location) => LatLngTile(location)),
          ],
        ),
      ),
    ));
  }
}
