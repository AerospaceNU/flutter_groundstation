import 'dart:collection';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_groundstation/widgets/test_widget.dart';
import 'base_widget.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_groundstation/widgets/map_widget.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});
  
  @override
  State<StatefulWidget> createState() => _MapWidgetState();
}




  
class _MapWidgetState extends BaseWidgetState<MapWidget> {


  @override
  Widget build(BuildContext context) {
    var lat = getDatabaseValue("latitude", 42.361);
    var long = getDatabaseValue("longitude", -71.057);
    return FlutterMap(
      options: MapOptions(
        center: LatLng(lat, long),
        //center: LatLng(42.361145, -71.0570803),
        zoom: 17,
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
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ), 
      ],
    );
  }
}
  
