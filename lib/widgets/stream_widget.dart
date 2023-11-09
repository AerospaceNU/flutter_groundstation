// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'base_widget.dart';
import 'dart:async';

class StreamWidget extends StatefulWidget {
  const StreamWidget({super.key});

  @override
  State<StreamWidget> createState() => _StreamWidgetState();
}

class _StreamWidgetState extends BaseWidgetState<StreamWidget> {
  @override
  Widget build(BuildContext context) {
    List<String> importantFields = ["groundTemperature"];

    Stream<int> getNumberStream() {
      return Stream.periodic(Duration(seconds: 1), (int count) {
        return count;
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("It's streaming time"),
        StreamBuilder<int>(
          stream: getNumberStream(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              // Display the data from the stream
              return Text('Number: ${snapshot.data}');
            } else if (snapshot.hasError) {
              // Handle error case
              return Text('Error: ${snapshot.error}');
            } else {
              // Handle loading or initial state
              return CircularProgressIndicator();
            }
          },
        )
      ],
    );
  }
}
