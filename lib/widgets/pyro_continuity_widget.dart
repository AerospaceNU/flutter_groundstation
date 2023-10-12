// ignore_for_file: unused_local_variable

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'base_widget.dart';

class PyroContinuityWidget extends StatefulWidget {
  const PyroContinuityWidget({super.key});

  @override
  State<PyroContinuityWidget> createState() => _PyroWidgetState();
}

class _PyroWidgetState extends BaseWidgetState<PyroContinuityWidget> {
  var event = ['Approved', 'Rejected', 'Approved', 'Approved', 'Approved', 'Approved'];

  _PyroWidgetState() {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          // First Row
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: const Center(
                    child: Text('Pyro Continuity Status'),
                  ),
                ),
              ),
            ],
          ),
          // Second Row with 6 Columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: _getColorByEvent(event[0].toString()),
                    border: Border.all(color: Colors.black)),
                  child: const Center(
                    child: Text('1'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: _getColorByEvent(event[1].toString()),
                    border: Border.all(color: Colors.black)),
                  child: const Center(
                    child: Text('2'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: _getColorByEvent(event[2].toString()),
                    border: Border.all(color: Colors.black)),
                  child: const Center(
                    child: Text('3'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: _getColorByEvent(event[3].toString()),
                    border: Border.all(color: Colors.black)),
                  child: const Center(
                    child: Text('4'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: _getColorByEvent(event[4].toString()),
                    border: Border.all(color: Colors.black)),
                  child: const Center(
                    child: Text('5'),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: _getColorByEvent(event[5].toString()),
                    border: Border.all(color: Colors.black)),
                  child: const Center(
                    child: Text('6'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color _getColorByEvent(String event) {
  if (event == "Approved") return Colors.green;
  if (event == "Rejected") return Colors.red;
  return Colors.white;
}

class _DragAreaStateStateful extends _PyroWidgetState {
  Offset position = Offset(100, 100);
  double prevScale = 1;
  double scale = 1;

  void updateScale(double zoom) => setState(() => scale = prevScale * zoom);
  void commitScale() => setState(() => prevScale = scale);
  void updatePosition(Offset newPosition) =>
      setState(() => position = newPosition);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) => updateScale(details.scale),
      onScaleEnd: (_) => commitScale(),
      child: Stack(
        children: [
          Positioned.fill(
              child: Container(color: Colors.amber.withOpacity(.4))),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Draggable(
              maxSimultaneousDrags: 1,
              feedback: widget,
              childWhenDragging: Opacity(
                opacity: .3,
                child: widget,
              ),
              onDragEnd: (details) => updatePosition(details.offset),
              child: Transform.scale(
                scale: scale,
                child: widget,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


