import 'dart:convert';
import 'package:flutter/material.dart';

class PropDataWidget extends StatelessWidget {
  const PropDataWidget({super.key});
  @override
  Widget build(BuildContext context) {
    String testJson = """
        { "valves": {
            "EX_SENSOR_1": {
                "valveState": "OPEN"
            },
            "EX_SENSOR_2": {
                "valveState": "CLOSED"
            },
            "EX_SENSOR_3": {
                "valveState": "INVALID"
            }
        }}
    """;

    dynamic dataJson = jsonDecode(testJson);

    List<Widget> sensor_readings = [];
    Map<String, dynamic> valvesJson = dataJson["valves"];
    for (final MapEntry<String, dynamic> valvePair in valvesJson.entries) {
      sensor_readings.add(Text("${valvePair.key} : ${valvePair.value["valveState"]}"));
    }

    return GridView.count(
      crossAxisCount: 3,
      children: sensor_readings,
    );
  }
}
