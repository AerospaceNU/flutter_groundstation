//import 'dart:collection';
import 'dart:math';

//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_groundstation/widgets/test_widget.dart';
import 'base_widget.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

//import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_groundstation/widgets/map_widget.dart';

double LatLonToDistance(loc1, loc2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((loc2.latitude - loc1.latitude) * p) / 2 + c(loc1.latitude * p) * c(loc2.latitude * p) * (1 - c((loc2.longitude - loc1.longitude) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MapWidgetState();
}

List<LatLng> circles = [];

class _MapWidgetState extends BaseWidgetState<MapWidget> {
  var groundstation_location = LatLng(42.361145, -71.0570803);
  List<LatLng> rocket_path = [];
  @override
  Widget build(BuildContext context) {
    var rocket_location = LatLng(getDatabaseValue("rocket latitude", 42.37), getDatabaseValue("rocket longitude", -71.06));
    if (rocket_path.isEmpty || LatLonToDistance(rocket_location, rocket_path.last) > 0.5) {
      rocket_path.add(rocket_location);
    }

    return FlutterMap(
      options: MapOptions(
        center: LatLng(groundstation_location.latitude, groundstation_location.longitude),
        zoom: 10,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
          //urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: rocket_path,
              color: Color.fromARGB(255, 29, 195, 241),
              strokeWidth: 4,
            ),
          ],
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: LatLng(rocket_location.latitude, rocket_location.longitude),
              radius: 5,
              color: Color.fromARGB(255, 133, 2, 255),
            ),
            CircleMarker(
              point: LatLng(groundstation_location.latitude, groundstation_location.longitude),
              radius: 5,
              color: Color.fromARGB(255, 255, 154, 2),
            )
          ],
        ),
      ],
    );
  }
}
