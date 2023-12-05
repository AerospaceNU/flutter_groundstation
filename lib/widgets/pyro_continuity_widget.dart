// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'base_widget.dart';

import '../constants.dart';

class PyroContinuityWidget extends StatefulWidget {
  const PyroContinuityWidget({Key? key}) : super(key: key);

  @override
  _PyroContinuityWidgetState createState() => _PyroContinuityWidgetState();
}

class _PyroContinuityWidgetState extends BaseWidgetState<PyroContinuityWidget> {
  final Offset _position = const Offset(100, 100);

  //_PyroWidgetState();

  @override
  Widget build(BuildContext context) {
    List<bool> wid_3 = getDatabaseValue(Constants.pyroContinuity, []);
    int maxPyros = wid_3.length;

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
              for (int i = 0; i < maxPyros; i++)
                Expanded(
                    child: Container(
                  height: 75,
                  decoration: BoxDecoration(color: _getColorByEvent(wid_3[i]), border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text((i + 1).toString()),
                  ),
                )),
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
