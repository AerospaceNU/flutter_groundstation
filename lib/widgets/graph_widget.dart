// ignore_for_file: unused_local_variable

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'base_widget.dart';

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

    for (var key in pointsList.keys) {
      pointsList[key]?.add(FlSpot(time, getDatabaseValue(key, 0.0)));
    }

    stopwatch.stop();
    var dt_1 = stopwatch.elapsedMicroseconds;
    stopwatch.reset();
    stopwatch.start();

    // hack for min/max axis ranges. We apparently need to do it since we only create LineChartData once
    data.minX = time - 30;
    data.maxX = time;
    data.minY = -5;
    data.maxY = 10;

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
  var ret = LineChartData(
    // lineTouchData: const LineTouchData(enabled: false, ), // Setting this to false throws LateInitializationError: Field 'mostLeftSpot' has not been initialized.
    lineBarsData: points
        .map(
          (it) => LineChartBarData(
            spots: it,
            isCurved: false,
            dotData: const FlDotData(
              show: false,
            ),
          ),
        )
        .toList(),
  );

  return ret;
}
