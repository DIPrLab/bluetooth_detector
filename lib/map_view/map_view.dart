import 'dart:io';
import 'dart:math';

import 'package:bluetooth_detector/map_view/build_marker_widget.dart';
import 'package:bluetooth_detector/map_view/tile_servers.dart';
import 'package:bluetooth_detector/report/device.dart';
import 'package:bluetooth_detector/report/report.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:bluetooth_detector/settings.dart';

part 'package:bluetooth_detector/map_view/map_view_controllers.dart';

double clamp(double x, double min, double max) {
  if (x < min) x = min;
  if (x > max) x = max;
  return x;
}

class MapView extends StatefulWidget {
  final Device device;
  MapController? controller;
  final Settings settings;

  MapView(
    this.device,
    this.settings, {
    super.key,
    this.controller,
  });

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  Offset? dragStart;
  double scaleStart = 1.0;

  @override
  void initState() {
    super.initState();

    widget.controller = widget.controller ??
        MapController(
          location: LatLng.degree(45.511280676982636, -122.68334923167914),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLayout(
        controller: widget.controller!,
        builder: (context, transformer) {
          List<Widget>? markerWidgets = widget.device
              .locations()
              .toList()
              .map((location) => buildMarkerWidget(
                  context,
                  transformer.toOffset(location),
                  Icon(
                    Icons.circle,
                    color: Colors.red,
                    size: 24.0,
                  ),
                  false))
              .toList();
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTapDown: (details) => onDoubleTap(
              transformer,
              details.localPosition,
            ),
            onScaleStart: onScaleStart,
            onScaleUpdate: (details) => onScaleUpdate(details, transformer),
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  transformer.setZoomInPlace(
                      clamp(
                          widget.controller!.zoom +
                              event.scrollDelta.dy / -1000.0,
                          2,
                          18),
                      event.localPosition);
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  TileLayer(
                    builder: (context, x, y, z) {
                      final tilesInZoom = pow(2.0, z).floor();

                      while (x < 0) {
                        x += tilesInZoom;
                      }
                      while (y < 0) {
                        y += tilesInZoom;
                      }

                      x %= tilesInZoom;
                      y %= tilesInZoom;

                      return CachedNetworkImage(
                        imageUrl: mapbox(z, x, y),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  CustomPaint(
                    painter: PolylinePainter(
                        transformer, widget.device, widget.settings),
                  ),
                  ...markerWidgets,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PolylinePainter extends CustomPainter {
  PolylinePainter(this.transformer, this.device, this.settings);

  Device device;
  Settings settings;
  final MapTransformer transformer;

  Offset generateOffsetPosition(Position p) {
    LatLng coordinate = LatLng.degree(p.latitude, p.longitude);
    return transformer.toOffset(coordinate);
  }

  Offset generateOffsetLatLng(LatLng coordinate) {
    return transformer.toOffset(coordinate);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 4;
    device.paths(settings.thresholdTime.toInt()).forEach((Path path) {
      for (int i = 0; i < path.length - 1; i++) {
        Offset p1 = generateOffsetLatLng(path[i].location);
        Offset p2 = generateOffsetLatLng(path[i + 1].location);
        canvas.drawLine(p1, p2, paint);
      }
    });
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(PolylinePainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(PolylinePainter oldDelegate) => false;
}
