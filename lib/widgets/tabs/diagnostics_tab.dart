import 'package:flutter/material.dart';

import '../pyro_continuity_widget.dart';
import '../pyro_data_widget.dart';

import 'package:flutter/material.dart';


class DiagnosticsTab extends StatelessWidget {
  const DiagnosticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    //return GridView.count(
      //primary: false,
      //padding: const EdgeInsets.all(20),
      //crossAxisSpacing: 10,
      //mainAxisSpacing: 10,
      //crossAxisCount: 3,
      //children: const <Widget>[
        //PyroContinuityWidget(),
        //PyroDataWidget(),
      //],
      //return MaterialApp(
      //home: Scaffold(
        
        //body: DraggablePage(),
      //),
    //);
    //);
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        const PyroContinuityWidget(),
        const PyroDataWidget(),
      ]
    );
  }
}

/*

class DiagnosticsTab extends StatefulWidget {
  @override
  _DiagnosticsTabState createState() => _DiagnosticsTabState();
}

class _DiagnosticsTabState extends State<DiagnosticsTab> {
  List<DraggableWidget> draggableWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        for (var widget in draggableWidgets)
          Positioned(
            left: widget.position.dx,
            top: widget.position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  widget.position += details.delta;
                });
              },
              child: widget.widget,
            ),
          ),
        Positioned(
          left: 150, // Adjust the initial position as needed
          top: 150, // Adjust the initial position as needed
          child: DragTarget(
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 100,
                height: 100,
                color: Colors.red,
              );
            },
            onWillAccept: (data) => true,
            onAccept: (DraggableWidget data) {
              setState(() {
                draggableWidgets.add(data);
              });
            },
          ),
        ),
      ],
    );
  }
}

class DraggableWidget {
  final Widget widget;
  Offset position;

  DraggableWidget(this.widget, this.position);
}






class DraggableExample extends StatefulWidget {
  const DraggableExample({super.key});

  @override
  State<DraggableExample> createState() => _DraggableExampleState();
}

class _DraggableExampleState extends State<DraggableExample> {
  int acceptedData = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Draggable<int>(
          // Data is the value this Draggable stores.
          data: 10,
          feedback: Container(
            color: Colors.deepOrange,
            height: 100,
            width: 100,
            child: const Icon(Icons.directions_run),
          ),
          childWhenDragging: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.pinkAccent,
            child: const Center(
              child: Text('Child When Dragging'),
            ),
          ),
          child: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.lightGreenAccent,
            child: const Center(
              child: Text('Draggable'),
            ),
          ),
        ),
        DragTarget<int>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Container(
              height: 100.0,
              width: 100.0,
              color: Colors.cyan,
              child: Center(
                child: Text('Value is updated to: $acceptedData'),
              ),
            );
          },
          onAccept: (int data) {
            setState(() {
              acceptedData += data;
            });
          },
        ),
      ],
    );
  }
}


class DraggablePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DraggablePageState();
  }
}

class _DraggablePageState extends State<DraggablePage> {
  double width = 100.0, height = 100.0;
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = Offset(0.0, height - 20);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: position.dx,
          //top: position.dy - height + 20,
          child: Draggable(
            feedback: Container(
              color: Colors.red[800],
              width: width,
              height: height,
            ),
            onDraggableCanceled: (Velocity velocity, Offset offset){
              setState(() => position = offset);
            },
            child: const Row(
              children: <Widget>[
              PyroContinuityWidget(),
              PyroDataWidget(),
            ],
            ),
          ),
        ),
      ],
    );
  }
}
*/