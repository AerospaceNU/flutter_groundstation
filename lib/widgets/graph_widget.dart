// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'base_widget.dart';

import '../color_names.dart';

class GraphWidget extends StatefulWidget {
  final String title;
  final List keyList;

  const GraphWidget({required this.title, required this.keyList, super.key});

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends BaseWidgetState<GraphWidget> {
  Map<String, List<FlSpot>> pointsList = {};

  late LineChartData data;
  var startTime = DateTime.now().millisecondsSinceEpoch / 1000;

  var maxValue = 0.0;
  var minValue = 0.0;

  @override
  void initState() {
    super.initState();

    for (var key in widget.keyList) {
      pointsList[key] = List.empty(growable: true);
    }

    if (pointsList.keys.isEmpty) {
      pointsList["_"] = List.empty(growable: true);
    }

    data = makeChart(pointsList.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    var time = DateTime.now().millisecondsSinceEpoch / 1000 - startTime;

    var timeToKeep = 30;
    var oldestToKeep = time - timeToKeep;

    //Loop through the lines we track, get data from the database, and add it to the line
    for (var key in pointsList.keys) {
      //Get value from database
      var value = getDatabaseValue(key, 0.0);

      //Track min and max values (this needs work eventually), since these will never get smaller
      maxValue = max(maxValue, value);
      minValue = min(minValue, value);

      //Add it to the line
      pointsList[key]?.add(FlSpot(time, value));

      //Remove old data
      var needsToKeepRemoving = true;
      while (needsToKeepRemoving) {
        if (pointsList[key]![0].x < oldestToKeep - 5) {
          pointsList[key]!.removeAt(0);
        } else {
          needsToKeepRemoving = false;
        }
      }
    }

    stopwatch.stop();
    var dt_1 = stopwatch.elapsedMicroseconds;
    stopwatch.reset();
    stopwatch.start();

    // hack for min/max axis ranges. We apparently need to do it since we only create LineChartData once
    data.minX = oldestToKeep;
    data.maxX = time;
    data.minY = minValue;
    data.maxY = maxValue;

    stopwatch.stop();
    var dt_2 = stopwatch.elapsedMicroseconds;
    stopwatch.reset();
    stopwatch.start();

    // return chart;
    var ret = Column(
      children: <Widget>[
        Center(child: Text(widget.title)),
        AspectRatio(
          aspectRatio: 2,
          child: LineChart(data, duration: const Duration(milliseconds: 0)),
        ),
      ],
    );

    stopwatch.stop();
    var dt_3 = stopwatch.elapsedMicroseconds;
    stopwatch.reset();
    stopwatch.start();

    // print("dt append ${dt_1} make_chart ${dt_2} list_view ${dt_3}");

    return ret;
  }
}

// This is pretty expensive to do, so try to avoid doing it very often
makeChart(List<List<FlSpot>> points) {
  var lineColors = ["red", "blue", "green", "magenta"];

  var lineChartBarData = <LineChartBarData>[];
  for (var i = 0; i < points.length; i++) {
    lineChartBarData.add(LineChartBarData(
      spots: points[i],
      isCurved: false,
      dotData: const FlDotData(show: false),
      color: colorFromName(lineColors[i % lineColors.length]),
    ));
  }

  var ret = LineChartData(
    // lineTouchData: const LineTouchData(enabled: false, ), // Setting this to false throws LateInitializationError: Field 'mostLeftSpot' has not been initialized.
    lineBarsData: lineChartBarData,
    clipData: const FlClipData.all(),
  );

  return ret;
}
