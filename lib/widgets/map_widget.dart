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

late List<LatLng> circles;



  
class _MapWidgetState extends BaseWidgetState<MapWidget> {
 

  @override
  Widget build(BuildContext context) {
    var lat = getDatabaseValue("latitude", 42.361145);
    var lon = getDatabaseValue("longitude", -71.0570803);

    var groundstation_lat = 42.35;
    var groundstation_lon = -71.06;
    return FlutterMap(
      options: MapOptions(
        center: LatLng(lat, lon),
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
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ), 
        CircleLayer(
                  circles: [
                    CircleMarker(
                      point: LatLng(lat, lon),
                      radius: 8,
                      color: Color.fromARGB(255, 133, 2, 255),
                    ),
                    CircleMarker(
                      point: LatLng(groundstation_lat, groundstation_lon),
                      radius: 8,
                      color: Color.fromARGB(255, 255, 154, 2),
                    )
                  ],
                ),
      ],
    );
  }
}
  
