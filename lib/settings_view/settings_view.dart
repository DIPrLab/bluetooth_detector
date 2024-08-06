import 'dart:math';

import 'package:bluetooth_detector/styles/button_styles.dart';
import 'package:bluetooth_detector/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  SettingsViewState createState() => SettingsViewState();
}

class LocationHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddLocation;

  LocationHeader({required this.onAddLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.background,
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.add, color: colors.primaryText),
          onPressed: onAddLocation,
        ),
        title: Text("Add New Safe Zone", style: TextStyle(color: colors.primaryText)),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SettingsViewState extends State<SettingsView> {
  List<LatLng> locations = [
    LatLng.degree(111.111, 222.222),
    LatLng.degree(333.333, 444.444),
    LatLng.degree(555.555, 777.777),
    LatLng.degree(888.888, 999.999),
  ];

  double scanTime = 20;
  double thresholdTime = 20;
  double scanDistance = 20;
  double thresholdDistance = 20;

  void _addLocation() {
    setState(() {
      locations.insert(0, LatLng.degree(123.456, 789.012));
    });
  }

  void save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("scanTime", scanTime);
    await prefs.setDouble("thresholdTime", thresholdTime);
    await prefs.setDouble("scanDistance", scanTime);
    await prefs.setDouble("thresholdDistance", thresholdTime);
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BackButton(
              color: colors.primaryText,
              onPressed: () => Navigator.pop(context),
              style: AppButtonStyle.buttonWithoutBackground,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Metrics",
                style: TextStyle(color: colors.primaryText, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Time",
                style: TextStyle(color: colors.primaryText, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text('Scanning Time', style: TextStyle(color: colors.primaryText, fontSize: 18)),
            Slider(
              activeColor: colors.altText,
              min: 0.0,
              max: 100.0,
              value: scanTime,
              onChanged: (newValue) {
                setState(() {
                  scanTime = newValue;
                  thresholdTime = max(scanTime, thresholdTime);
                  save();
                });
              },
            ),
            Text('Scanning Time threshold', style: TextStyle(color: colors.primaryText, fontSize: 18)),
            Slider(
              activeColor: colors.altText,
              min: 0.0,
              max: 100.0,
              value: thresholdTime,
              onChanged: (newValue) {
                setState(() {
                  thresholdTime = max(scanTime, newValue);
                  save();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Distance",
                style: TextStyle(color: colors.primaryText, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text('Scanning Distance', style: TextStyle(color: colors.primaryText, fontSize: 18)),
            Slider(
              activeColor: colors.altText,
              min: 0.0,
              max: 100.0,
              value: scanDistance,
              onChanged: (newValue) {
                setState(() {
                  scanDistance = newValue;
                  thresholdDistance = max(scanDistance, thresholdDistance);
                  save();
                });
              },
            ),
            Text('Scanning Distance threshold', style: TextStyle(color: colors.primaryText, fontSize: 18)),
            Slider(
              activeColor: colors.altText,
              min: 0.0,
              max: 100.0,
              value: thresholdDistance,
              onChanged: (newValue) {
                setState(() {
                  thresholdDistance = max(scanDistance, newValue);
                  save();
                });
              },
            ),
            Flexible(
                child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "\nSafe Zones",
                  style: TextStyle(color: colors.primaryText, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              LocationHeader(onAddLocation: _addLocation),
              ...locations.map((location) => ListTile(
                    title: Text('Latitude: ${location.latitude}, Longitude: ${location.longitude}',
                        style: TextStyle(color: colors.primaryText)),
                  )),
            ]))),
          ],
        ),
      ),
    );
  }
}
