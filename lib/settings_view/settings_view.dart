import 'dart:math';

import 'package:bluetooth_detector/map_view/map_functions.dart';
import 'package:bluetooth_detector/styles/styles.dart';
import 'package:bluetooth_detector/settings_view/LatLngTile.dart';
import 'package:bluetooth_detector/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddLocation;

  LocationHeader({required this.onAddLocation});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: onAddLocation,
        ),
        title: Text(
          "Add New Safe Zone",
        ),
      ),
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SettingsView extends StatefulWidget {
  SettingsView(Settings this.settings, {super.key});

  Settings settings;

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
              .map((z) => z.latitude.degrees.toString() + "," + z.longitude.degrees.toString())
              .toList());
    });
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
            Text(
              "Metrics",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Text(
                "Time",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Row(children: [
              Text(
                'Scanning Time',
              ),
              Spacer(),
              Text(
                widget.settings.scanTime.toInt().toString() + " seconds",
              ),
            ]),
            Slider(
              min: 0.0,
              max: 100.0,
              value: widget.settings.scanTime,
              onChanged: (newValue) {
                setState(() {
                  widget.settings.scanTime = newValue;
                  widget.settings.thresholdTime = max(widget.settings.scanTime, widget.settings.thresholdTime);
                  save();
                });
              },
            ),
            Row(children: [
              Text(
                'Scanning Time threshold',
              ),
              Spacer(),
              Text(
                widget.settings.thresholdTime.toInt().toString() + " seconds",
              ),
            ]),
            Slider(
              min: 0.0,
              max: 100.0,
              value: widget.settings.thresholdTime,
              onChanged: (newValue) {
                setState(() {
                  widget.settings.thresholdTime = newValue;
                  widget.settings.scanTime = min(widget.settings.scanTime, newValue);
                  save();
                });
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Text(
                  "Distance",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
            Row(children: [
              Text(
                'Scanning Distance',
              ),
              Spacer(),
              Text(
                widget.settings.scanDistance.toInt().toString() + " meters",
              ),
            ]),
            Slider(
              min: 0.0,
              max: 100.0,
              value: widget.settings.scanDistance,
              onChanged: (newValue) {
                setState(() {
                  widget.settings.scanDistance = newValue;
                  widget.settings.thresholdDistance =
                      max(widget.settings.scanDistance, widget.settings.thresholdDistance);
                  save();
                });
              },
            ),
            Row(children: [
              Text(
                'Scanning Distance threshold',
              ),
              Spacer(),
              Text(
                widget.settings.thresholdDistance.toInt().toString() + " meters",
              ),
            ]),
            Slider(
              min: 0.0,
              max: 100.0,
              value: widget.settings.thresholdDistance,
              onChanged: (newValue) {
                setState(() {
                  widget.settings.thresholdDistance = newValue;
                  widget.settings.scanDistance = min(widget.settings.scanDistance, newValue);
                  save();
                });
              },
            ),
            Flexible(
                child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Text(
                  "Safe Zones",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              LocationHeader(onAddLocation: _addLocation),
              ...widget.settings.safeZones.map(
                (location) => LatLngTile(location),
              ),
            ]))),
          ],
        ),
      ),
    ));
  }
}
