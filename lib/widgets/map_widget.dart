import 'dart:math';

//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'base_widget.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_groundstation/widgets/map_widget.dart';

import '../constants.dart';

double latLonToDistance(loc1, loc2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((loc2.latitude - loc1.latitude) * p) / 2 + c(loc1.latitude * p) * c(loc2.latitude * p) * (1 - c((loc2.longitude - loc1.longitude) * p)) / 2;
  return 12742 * asin(sqrt(a)) * 1000;
}

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends BaseWidgetState<MapWidget> {
  List<LatLng> rocketPath = [];
  List<LatLng> circles = [];

  @override
  Widget build(BuildContext context) {
    var groundstationLocation = LatLng(getDatabaseValue(Constants.groundStationLatitude, 0), getDatabaseValue(Constants.groundStationLongitude, 0));
    var rocketLocation = LatLng(getDatabaseValue(Constants.latitude, 0), getDatabaseValue(Constants.longitude, 0));

    //If we don't have a location
    if (rocketLocation.latitude == 0 && rocketLocation.longitude == 0) {
      return Container(
        padding: const EdgeInsets.all(8),
        color: const Color.fromARGB(255, 30, 144, 255),
      );
    }

    //Add current rocket location to path
    if (rocketPath.isEmpty || latLonToDistance(rocketLocation, rocketPath.last) > 5) {
      rocketPath.add(rocketLocation);
    }

    //Make map
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(groundstationLocation.latitude, groundstationLocation.longitude),
        initialZoom: 17,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
          //urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: rocketPath,
              color: const Color.fromARGB(255, 29, 195, 241),
              strokeWidth: 4,
            ),
          ],
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: LatLng(rocketLocation.latitude, rocketLocation.longitude),
              radius: 5,
              color: const Color.fromARGB(255, 133, 2, 255),
            ),
            CircleMarker(
              point: LatLng(groundstationLocation.latitude, groundstationLocation.longitude),
              radius: 5,
              color: const Color.fromARGB(255, 255, 154, 2),
            )
          ],
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
    );
  }
}
