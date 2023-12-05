import 'package:flutter/material.dart';

import '../graph_widget.dart';
import '../../constants.dart';

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
      childAspectRatio: 1.8,
      //TODO: This displays really funny, IDK why
      children: const <Widget>[
        GraphWidget(title: "Altitude", keyList: [Constants.altitude, Constants.gpsAltitude]),
        GraphWidget(title: "Speeds", keyList: [Constants.verticalSpeed, Constants.groundSpeed]),
        GraphWidget(title: "XYZ Accelerations", keyList: [Constants.accelerometerX, Constants.accelerometerY, Constants.accelerometerZ]),
        GraphWidget(title: "RPY Orientation", keyList: [Constants.roll, Constants.pitch, Constants.yaw]),
        GraphWidget(title: "XYZ Rotational Velocities", keyList: [Constants.gyroX, Constants.gyroY, Constants.gyroZ]),
        GraphWidget(title: "Magnetometer", keyList: [Constants.magnetometerX, Constants.magnetometerY, Constants.magnetometerZ]),
        GraphWidget(title: "Pressure, Pressure, & Pressure", keyList: [Constants.barometer1Pressure, Constants.barometer2Pressure, Constants.pressureReference]),
        GraphWidget(title: "State", keyList: [Constants.fcbStateNumber]),
        GraphWidget(title: "RSSI", keyList: [Constants.rssi]),
      ],
    );
  }
}
