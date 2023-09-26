import 'package:flutter/material.dart';

import '../graph_widget.dart';

class GraphTab extends StatelessWidget {
  const GraphTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
//      crossAxisSpacing: 10,
//      mainAxisSpacing: 10,
      crossAxisCount: 3,
      childAspectRatio: 1.8, //TODO: This displays really funny, IDK why
      children: const <Widget>[
        GraphWidget(title: "Altitude", keyList: []),
        GraphWidget(title: "Speeds", keyList: []),
        GraphWidget(title: "XYZ Accelerations", keyList: []),
        GraphWidget(title: "RPY Orientation", keyList: []),
        GraphWidget(title: "XYZ Rotational Velocities", keyList: []),
        GraphWidget(title: "Magnetometer", keyList: []),
        GraphWidget(title: "Pressure, Pressure, & Pressure", keyList: []),
        GraphWidget(title: "State", keyList: []),
        GraphWidget(title: "RSSI", keyList: ["rssi"]),
      ],
    );
  }
}
