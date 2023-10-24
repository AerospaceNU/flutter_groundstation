import 'package:flutter/material.dart';

import '../pyro_continuity_widget.dart';
import '../pyro_data_widget.dart';

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
    return Stack(
      children: [
        Container(
          width: 100, // Define the width of the constrained area
          height: 100, // Define the height of the constrained area
          color: Colors.grey,
        ),
        PyroContinuityWidget(),
        PyroDataWidget(),
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