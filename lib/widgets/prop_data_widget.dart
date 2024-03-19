import 'dart:convert';
import 'package:flutter/material.dart';

class PropDataWidget extends StatelessWidget {
  const PropDataWidget({super.key});
  @override
  Widget build(BuildContext context) {
    String testJson = """
    {
      "loadCellSensors": {
          "EX_LOAD_1": {
              "sensorReading": -5.476813068846521,
              "unit": "LBS"
          }
      },
      "pressureSensors": {
          "EX_PRESS_2": {
              "sensorReading": 2.2792993667654207,
              "unit": "PSI"
          },
          "EX_PRESS_3": {
              "sensorReading": 7.950959608789882,
              "unit": "KG_PER_SEC"
          }
      },
      "tempSensors": {
          "EX_TEMP_4": {
              "sensorReading": 26.16680223534908,
              "unit": "CELSIUS"
          }
      },
      "valves": {
          "EX_SENSOR_1": {
              "valveState": "OPEN"
          },
          "EX_SENSOR_2": {
              "valveState": "CLOSED"
          },
          "EX_SENSOR_3": {
              "valveState": "INVALID"
          }
      }
    }
    """;

    dynamic dataJson = jsonDecode(testJson);

    List<Widget> sensorReadings = [];
    Map<String, dynamic> valvesJson = dataJson["valves"];
    for (final MapEntry<String, dynamic> valvePair in valvesJson.entries) {
      sensorReadings.add(Text("${valvePair.key} : ${valvePair.value["valveState"]}"));
    }

    Map<String, dynamic> tempsJson = dataJson["tempSensors"];
    for (final MapEntry<String, dynamic> tempPair in tempsJson.entries) {
      sensorReadings.add(Text("${tempPair.key} : ${tempPair.value["sensorReading"]}"));
    }

    Map<String, dynamic> pressJson = dataJson["pressureSensors"];
    for (final MapEntry<String, dynamic> pressPair in pressJson.entries) {
      sensorReadings.add(Text("${pressPair.key} : ${pressPair.value["sensorReading"]}"));
    }

    Map<String, dynamic> loadsJson = dataJson["loadCellSensors"];
    for (final MapEntry<String, dynamic> loadCellPair in loadsJson.entries) {
      sensorReadings.add(Text("${loadCellPair.key} : ${loadCellPair.value["sensorReading"]}"));
    }

    return GridView.count(
      crossAxisCount: 3,
      children: sensorReadings,
    );
  }
}
