// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'base_widget.dart';
import 'dart:ui';


class PyroContinuityWidget extends StatefulWidget {
  const PyroContinuityWidget({Key? key}) : super(key: key);


  @override
  _PyroContinuityWidgetState createState() => _PyroContinuityWidgetState();
}

class _PyroContinuityWidgetState extends BaseWidgetState<PyroContinuityWidget> {
  
  Offset _position = Offset(100, 100);
  //_PyroWidgetState();

  @override
  Widget build(BuildContext context) {
    List<bool> wid_3 = getDatabaseValue("pyro-status", []);
    int max_pyros = wid_3.length;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (int i = 0; i < max_pyros; i++) Expanded(child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: _getColorByEvent(wid_3[i]),
                    border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text((i+1).toString()),
                  ),
                )
              ),
            ],
          ),
        ],
      ),
    );
    /*
    return Positioned(
      left: position.dx, 
      top: position.dy, 
      child: Draggable(
        feedback: Container(
          
        ),
        child: Container(
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (int i = 0; i < max_pyros; i++) Expanded(child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: _getColorByEvent(event[i]),
                    border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text((i+1).toString()),
                  ),
                )
              ),
            ],
          ),
        ]
      )
        ),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            // Constrain the position within the tab's bounding box
            position = Offset(
              offset.dx.clamp(0, 200 - 100), // 200 is the width of the constrained area
              offset.dy.clamp(0, 200 - 100), // 200 is the height of the constrained area
            );
          });
        },
      ),
    );*/
  }
}

// changes the color based on input data
Color _getColorByEvent(bool event) {
  if (event == true) return Colors.green;
  if (event == false) return Colors.red;
  return Colors.white;
}

/*
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (int i = 0; i < max_pyros; i++) Expanded(child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: _getColorByEvent(event[i]),
                    border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text((i+1).toString()),
                  ),
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// changes the color based on input data
Color _getColorByEvent(bool event) {
  if (event == true) return Colors.green;
  if (event == false) return Colors.red;
  return Colors.white;
}

// was trying to make it draggable - it didn't cooperate
class _DragAreaStateStateful extends _PyroWidgetState {
  Offset position = const Offset(100, 100);
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
              onDraggableCanceled: (Velocity velocity, Offset offset){
                setState(() => position = offset);
              },
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

*/
