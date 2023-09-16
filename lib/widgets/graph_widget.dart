import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'base_widget.dart';


class GraphWidget extends StatefulWidget {
  const GraphWidget({super.key});

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

// This is pretty expensive to do, so try to avoid doing it very often
make_chart(List<List<FlSpot>> points) {
    var ret = LineChartData(
          // lineTouchData: const LineTouchData(enabled: false, ), // Setting this to false throws LateInitializationError: Field 'mostLeftSpot' has not been initialized.
          lineBarsData: points.map((it) => 
            LineChartBarData(
              spots: it,
              isCurved: false,
              dotData: const FlDotData(
                show: false,
              ),
            ),
          ).toList(),
        );

      return ret;
  }

class _GraphWidgetState extends BaseWidgetState<GraphWidget> {
  _GraphWidgetState() {
    subscribeToDatabaseKey("test");
    data = make_chart([points, points2, points3]);
  }

  List<FlSpot> points = List.empty(growable: true);
  List<FlSpot> points2 = List.empty(growable: true);
  List<FlSpot> points3 = List.empty(growable: true);

  late LineChartData data;
 

  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    var counter = getDatabaseValue("test", 0).toDouble();
    points.add(FlSpot(counter, sin(counter / 50) + 0));
    var counter2 = getDatabaseValue("test", 0).toDouble();
    points2.add(FlSpot(counter2, sin(counter / 5) + 3));
    var counter3 = getDatabaseValue("test", 0).toDouble();
    points3.add(FlSpot(counter3, sin(counter / 50) + 6));

    stopwatch.stop();
    var dt_1 = stopwatch.elapsedMicroseconds; 
    stopwatch.reset(); stopwatch.start();

    // hack for min/max axis ranges. We apparently need to do it since we only create LineChartData once
    this.data.minX = 0;
    this.data.maxX = counter;
    this.data.minY = -5;
    this.data.maxY = 10;

    stopwatch.stop();
    var dt_2 = stopwatch.elapsedMicroseconds; 
    stopwatch.reset(); stopwatch.start();

    // return chart;
    var ret = ListView(
      shrinkWrap: true,
      children: <Widget>[AspectRatio(aspectRatio: 6, child: LineChart(
        data,
        duration: Duration(milliseconds: 0),
      ))],
    );

    stopwatch.stop();
    var dt_3 = stopwatch.elapsedMicroseconds; 
    stopwatch.reset(); stopwatch.start();

    // print("dt append ${dt_1} make_chart ${dt_2} list_view ${dt_3}");

    return ret;
  }
}
