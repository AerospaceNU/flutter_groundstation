// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'base_widget.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class StreamWidget extends StatefulWidget {
  const StreamWidget({super.key});

  @override
  State<StreamWidget> createState() => _StreamWidgetState();
}

Future<String> get _localPath async {
      final directory = await getApplicationDocumentsDirectory();

      return directory.path;
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

    Stream<String> getGyroStream() {
      final File file = new File("/Users/elyssaadams/Documents/sprucegoose-11-19-2-output-FCB-post.csv");

      Stream<List> inputStream = file.openRead();

      Stream<String> stringStream = inputStream
        .transform(utf8.decoder)          // Decode bytes to UTF-8.
        .transform(new LineSplitter());    // Convert stream to individual lines.
      return stringStream;
      }

  
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("It's streaming time"),
        StreamBuilder<String>(
          stream: getGyroStream(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              // Display the data from the stream
              return Text('Information: ${snapshot.data}');
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
