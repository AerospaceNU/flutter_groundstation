// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'base_widget.dart';

class PyroDataWidget extends StatefulWidget {
  const PyroDataWidget({super.key});

  @override
  State<PyroDataWidget> createState() => _PyroWidgetState();
}

class _PyroWidgetState extends BaseWidgetState<PyroDataWidget> {

  _PyroWidgetState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 600,
      child: Column(
        
        children: <Widget>[
          Container(
              height: 75,
              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: const Center(
                child: Text('Pyro Output Data'),
              ),
            ),
          SingleChildScrollView(
          child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black)),
              child: const Center(
                child: Text(
                  '1',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}